defmodule Discordex.Gateway.Payload do
  @moduledoc false

  alias Discordex.Types.Encodable
  alias Discordex.Types.Gateway.Identify

  @doc """
  Sends an Identify payload over the websocket.
  """
  @spec send_identify(pid(), Identify.t()) :: :ok
  def send_identify(ws, %Identify{} = payload) do
    frame = %{op: 2, d: Encodable.to_map(payload)} |> JSON.encode!()
    WebSockex.send_frame(ws, {:text, frame})
  end

  @doc """
  Sends a Heartbeat payload over the websocket.
  """
  @spec send_heartbeat(pid(), integer() | nil) :: :ok
  def send_heartbeat(ws, seq) do
    frame = %{op: 1, d: seq} |> JSON.encode!()
    WebSockex.send_frame(ws, {:text, frame})
  end
end
