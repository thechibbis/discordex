defmodule Discordex.Gateway.Shard do
  use GenStateMachine, callback_mode: [:handle_event_function]

  require Logger

  alias Discordex.{Dispatcher, Client}
  alias Discordex.Gateway.Payload, as: GatewayPayload
  alias Discordex.Types.{Intent, Message, Interaction}
  alias Discordex.Types.Gateway.{Payload, Identify, Identify.ConnectionProperties}

  @wss_url "wss://gateway.discord.gg/?v=10&encoding=json"

  def start_link(opts) do
    client = Keyword.fetch!(opts, :client)
    consumer = Keyword.fetch!(opts, :consumer)
    shard_id = Keyword.get(opts, :shard_id, 0)

    GenStateMachine.start_link(__MODULE__, {client, consumer, shard_id})
  end

  @impl true
  def init({%Client{} = client, consumer, shard_id}) do
    data = %{
      client: client,
      consumer: consumer,
      shard_id: shard_id,
      seq: nil,
      session_id: nil,
      heartbeat_interval: nil,
      ws: nil,
      shard_pid: self()
    }

    Logger.info("[shard #{shard_id}] init — token=#{String.slice(client.token, 0, 8)}... intents=#{inspect(client.intents)} consumer=#{inspect(consumer)}")
    {:ok, :disconnected, data, {:next_event, :internal, :connect}}
  end

  # -- :disconnected → :connecting ---------------------------------------

  @impl true
  def handle_event(:internal, :connect, :disconnected, data) do
    Logger.info("[shard #{data.shard_id}] connecting to #{@wss_url}")
    {:ok, ws} = WebSockex.start(@wss_url, __MODULE__, data)
    Logger.info("[shard #{data.shard_id}] websocket pid=#{inspect(ws)} → :connecting")
    {:next_state, :connecting, %{data | ws: ws}}
  end

  # -- :connecting → :identifying (handle HELLO) -------------------------

  def handle_event(:info, {:ws, {:text, raw}}, :connecting, data) do
    Logger.debug("[shard #{data.shard_id}] ws frame in :connecting: #{String.slice(raw, 0, 200)}")
    payload = raw |> JSON.decode!() |> Payload.decode()

    if payload.op != 10 do
      Logger.warning("[shard #{data.shard_id}] expected HELLO (op 10), got op #{payload.op} — waiting")
      {:keep_state, data}
    else
      interval = payload.d["heartbeat_interval"]
      Logger.info("[shard #{data.shard_id}] HELLO received — heartbeat_interval=#{interval}ms, sending IDENTIFY...")

      identify = %Identify{
        token: data.client.token,
        properties: %ConnectionProperties{
          os: "linux",
          browser: "discordex",
          device: "discordex"
        },
        intents: Intent.to_bitmask(data.client.intents)
      }

      GatewayPayload.send_identify(data.ws, identify)
      Process.send_after(self(), :heartbeat, interval)
      Logger.debug("[shard #{data.shard_id}] IDENTIFY sent, heartbeat timer armed → :identifying")

      {:next_state, :identifying, %{data | heartbeat_interval: interval}}
    end
  end

  # -- :identifying → :connected (handle READY) --------------------------

  def handle_event(:info, {:ws, {:text, raw}}, :identifying, data) do
    Logger.debug("[shard #{data.shard_id}] ws frame in :identifying: #{String.slice(raw, 0, 200)}")
    payload = raw |> JSON.decode!() |> Payload.decode()

    case payload do
      %{op: 0, t: "READY", d: ready_data, s: seq} ->
        user = ready_data["user"]
        Logger.info("[shard #{data.shard_id}] READY — gateway=#{ready_data["resume_gateway_url"]} session=#{ready_data["session_id"]} user=#{user["username"]}##{user["discriminator"]}")

        result = Dispatcher.dispatch(:ready, ready_data, data.consumer, data.client)
        Logger.debug("[shard #{data.shard_id}] handle_ready dispatched → #{inspect(result)}")
        {:next_state, :connected, %{data | seq: seq, session_id: ready_data["session_id"]}}

      %{op: 9} ->
        Logger.error("[shard #{data.shard_id}] INVALID_SESSION (op 9) — Discord rejected the session")
        {:next_state, :disconnected, %{data | ws: nil, seq: nil, session_id: nil}, {:next_event, :internal, :connect}}

      _ ->
        Logger.warning("[shard #{data.shard_id}] unexpected payload in :identifying — op=#{payload.op} t=#{inspect(payload.t)}")
        {:next_state, :identifying, data}
    end
  end

  # -- :connected (handle DISPATCH, heartbeat ack, reconnect) ------------

  def handle_event(:info, {:ws, {:text, raw}}, :connected, data) do
    payload = raw |> JSON.decode!() |> Payload.decode()

    case payload do
      %{op: 0, t: "INTERACTION_CREATE", d: interaction_data, s: seq} ->
        Logger.debug("[shard #{data.shard_id}] DISPATCH INTERACTION_CREATE")
        case Interaction.decode(interaction_data) do
          {:ok, interaction} ->
            Dispatcher.dispatch(:interaction_create, interaction, data.consumer, data.client)

          {:error, reason} ->
            Logger.warning("[shard #{data.shard_id}] failed to decode INTERACTION_CREATE: #{inspect(reason)}")
        end

        {:next_state, :connected, %{data | seq: seq}}

      %{op: 0, t: "MESSAGE_CREATE", d: message_data, s: seq} ->
        Logger.debug("[shard #{data.shard_id}] DISPATCH MESSAGE_CREATE")
        message = Message.decode(message_data)
        Dispatcher.dispatch(:message_create, message, data.consumer, data.client)
        {:next_state, :connected, %{data | seq: seq}}

      %{op: 0, t: event_type, s: seq} ->
        Logger.debug("[shard #{data.shard_id}] DISPATCH #{event_type} (unhandled)")
        {:next_state, :connected, %{data | seq: seq}}

      %{op: 11} ->
        Logger.debug("[shard #{data.shard_id}] HEARTBEAT_ACK")
        {:next_state, :connected, data}

      %{op: 7} ->
        Logger.warning("[shard #{data.shard_id}] RECONNECT requested by gateway — reconnecting")
        {:next_state, :disconnected, data, {:next_event, :internal, :connect}}

      _ ->
        Logger.debug("[shard #{data.shard_id}] unhandled payload — op=#{payload.op} t=#{inspect(payload.t)}")
        {:next_state, :connected, data}
    end
  end

  # -- Any state → :disconnected (handle ws_disconnect) ------------------

  def handle_event(:info, {:ws_disconnect, reason}, _state, data) do
    reason_str = case reason do
      %{reason: {:remote, code, msg}} -> "remote code=#{code} #{msg}"
      %{reason: {:local, msg}} -> "local: #{msg}"
      _ -> inspect(reason)
    end

    Logger.warning("[shard #{data.shard_id}] websocket disconnected — #{reason_str} — reconnecting...")
    {:next_state, :disconnected, %{data | ws: nil, seq: nil, session_id: nil}, {:next_event, :internal, :connect}}
  end

  # -- Heartbeat timer ---------------------------------------------------

  def handle_event(:info, :heartbeat, _state, data) do
    Logger.debug("[shard #{data.shard_id}] heartbeat — seq=#{data.seq}")
    if data.ws, do: GatewayPayload.send_heartbeat(data.ws, data.seq)
    Process.send_after(self(), :heartbeat, data.heartbeat_interval)
    {:keep_state, data}
  end

  # -- WebSockex callbacks (run in the WebSockex process) ----------------

  @doc false
  def handle_connect(_conn, state) do
    Logger.info("[shard #{state.shard_id}] ws connected to #{state.shard_pid |> inspect()}")
    {:ok, state}
  end

  @doc false
  def handle_disconnect(reason, state) do
    Logger.info("[shard #{state.shard_id}] ws disconnected (WebSockex) — reason=#{inspect(reason)}")
    send(state.shard_pid, {:ws_disconnect, reason})
    {:ok, state}
  end

  @doc false
  def handle_frame(frame, state) do
    Logger.debug("[shard #{state.shard_id}] ws frame: #{inspect(frame) |> String.slice(0, 250)}")
    send(state.shard_pid, {:ws, frame})
    {:ok, state}
  end

  @doc false
  def handle_cast(_msg, state) do
    {:ok, state}
  end

  @doc false
  def handle_info(_msg, state) do
    {:ok, state}
  end

  @doc false
  def handle_ping(:ping, state) do
    {:reply, :pong, state}
  end

  @doc false
  def handle_ping({:ping, _msg}, state) do
    {:reply, {:pong, nil}, state}
  end

  @doc false
  def handle_pong(_frame, state) do
    {:ok, state}
  end

  @doc false
  def terminate(reason, state) do
    Logger.info("[shard #{state.shard_id}] WebSockex terminating — reason=#{inspect(reason)}")
    :ok
  end
end
