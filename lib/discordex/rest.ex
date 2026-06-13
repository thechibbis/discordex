defmodule Discordex.Rest do
  @moduledoc """
  REST client for Discord's HTTP API.

  A `GenServer` that serialises HTTP requests through a single process so
  rate-limit tracking can be added later. The application ID is automatically
  discovered from Discord on startup — no config needed.

  ## Usage

      # From a consumer callback (receives a %Discordex.Client{}):
      Discordex.Rest.create_global_command(client.name, command)

  The `client_name` atom is used to derive the GenServer's registered name.
  """

  use GenServer

  alias Discordex.Types.ApplicationCommand
  alias Discordex.Types.Encodable

  @base_url "https://discord.com/api/v10"

  # -- Client API -----------------------------------------------------------

  def start_link(opts) do
    token = Keyword.fetch!(opts, :token)
    name = Keyword.fetch!(opts, :name)
    req = Keyword.get(opts, :req)
    application_id = Keyword.get(opts, :application_id)

    GenServer.start_link(
      __MODULE__,
      {token, name, req, application_id},
      name: via_tuple(name)
    )
  end

  # -- Global commands ------------------------------------------------------

  @spec create_global_command(atom(), ApplicationCommand.t()) ::
          {:ok, ApplicationCommand.t()} | {:error, term()}
  def create_global_command(client_name, command) do
    call(client_name, {:create_global, command})
  end

  @spec get_global_commands(atom()) ::
          {:ok, [ApplicationCommand.t()]} | {:error, term()}
  def get_global_commands(client_name) do
    call(client_name, :get_globals)
  end

  @spec get_global_command(atom(), String.t()) ::
          {:ok, ApplicationCommand.t()} | {:error, term()}
  def get_global_command(client_name, command_id) do
    call(client_name, {:get_global, command_id})
  end

  @spec edit_global_command(atom(), String.t(), ApplicationCommand.t()) ::
          {:ok, ApplicationCommand.t()} | {:error, term()}
  def edit_global_command(client_name, command_id, command) do
    call(client_name, {:edit_global, command_id, command})
  end

  @spec delete_global_command(atom(), String.t()) :: :ok | {:error, term()}
  def delete_global_command(client_name, command_id) do
    call(client_name, {:delete_global, command_id})
  end

  @spec bulk_overwrite_global_commands(atom(), [ApplicationCommand.t()]) ::
          {:ok, [ApplicationCommand.t()]} | {:error, term()}
  def bulk_overwrite_global_commands(client_name, commands) do
    call(client_name, {:bulk_overwrite_global, commands})
  end

  # -- Guild commands --------------------------------------------------------

  @spec create_guild_command(atom(), String.t(), ApplicationCommand.t()) ::
          {:ok, ApplicationCommand.t()} | {:error, term()}
  def create_guild_command(client_name, guild_id, command) do
    call(client_name, {:create_guild, guild_id, command})
  end

  @spec get_guild_commands(atom(), String.t()) ::
          {:ok, [ApplicationCommand.t()]} | {:error, term()}
  def get_guild_commands(client_name, guild_id) do
    call(client_name, {:get_guilds, guild_id})
  end

  @spec get_guild_command(atom(), String.t(), String.t()) ::
          {:ok, ApplicationCommand.t()} | {:error, term()}
  def get_guild_command(client_name, guild_id, command_id) do
    call(client_name, {:get_guild, guild_id, command_id})
  end

  @spec edit_guild_command(atom(), String.t(), String.t(), ApplicationCommand.t()) ::
          {:ok, ApplicationCommand.t()} | {:error, term()}
  def edit_guild_command(client_name, guild_id, command_id, command) do
    call(client_name, {:edit_guild, guild_id, command_id, command})
  end

  @spec delete_guild_command(atom(), String.t(), String.t()) :: :ok | {:error, term()}
  def delete_guild_command(client_name, guild_id, command_id) do
    call(client_name, {:delete_guild, guild_id, command_id})
  end

  @spec bulk_overwrite_guild_commands(atom(), String.t(), [ApplicationCommand.t()]) ::
          {:ok, [ApplicationCommand.t()]} | {:error, term()}
  def bulk_overwrite_guild_commands(client_name, guild_id, commands) do
    call(client_name, {:bulk_overwrite_guild, guild_id, commands})
  end

  # -- GenServer callbacks ---------------------------------------------------

  @impl true
  def init({token, _name, nil, nil}) do
    req =
      Req.new(base_url: @base_url)
      |> Req.merge(headers: %{authorization: "Bot #{token}"})

    {:ok, %{http: req, application_id: nil}, {:continue, :discover_application_id}}
  end

  def init({token, _name, req, nil}) do
    req =
      req
      |> ensure_base_url()
      |> Req.merge(headers: %{authorization: "Bot #{token}"})

    {:ok, %{http: req, application_id: nil}, {:continue, :discover_application_id}}
  end

  def init({token, _name, req, application_id}) when is_binary(application_id) do
    req =
      req
      |> ensure_base_url()
      |> Req.merge(headers: %{authorization: "Bot #{token}"})

    {:ok, %{http: req, application_id: application_id}}
  end

  @impl true
  def handle_continue(:discover_application_id, state) do
    case fetch_application_id(state.http) do
      {:ok, id} -> {:noreply, %{state | application_id: id}}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl true
  def handle_call(_msg, _from, %{application_id: nil} = state) do
    {:reply, {:error, :application_id_not_available}, state}
  end

  def handle_call({:create_global, command}, _from, state) do
    path = "/applications/#{state.application_id}/commands"
    req(state, :post, path, encode_body(command), &decode_body/1)
  end

  def handle_call(:get_globals, _from, state) do
    path = "/applications/#{state.application_id}/commands"
    req(state, :get, path, nil, &decode_body_list/1)
  end

  def handle_call({:get_global, command_id}, _from, state) do
    path = "/applications/#{state.application_id}/commands/#{command_id}"
    req(state, :get, path, nil, &decode_body/1)
  end

  def handle_call({:edit_global, command_id, command}, _from, state) do
    path = "/applications/#{state.application_id}/commands/#{command_id}"
    req(state, :patch, path, encode_body(command), &decode_body/1)
  end

  def handle_call({:delete_global, command_id}, _from, state) do
    path = "/applications/#{state.application_id}/commands/#{command_id}"
    req(state, :delete, path, nil, fn _ -> :ok end)
  end

  def handle_call({:bulk_overwrite_global, commands}, _from, state) do
    path = "/applications/#{state.application_id}/commands"
    body = Enum.map(commands, &encode_body/1)
    req(state, :put, path, body, &decode_body_list/1)
  end

  def handle_call({:create_guild, guild_id, command}, _from, state) do
    path = "/applications/#{state.application_id}/guilds/#{guild_id}/commands"
    req(state, :post, path, encode_body(command), &decode_body/1)
  end

  def handle_call({:get_guilds, guild_id}, _from, state) do
    path = "/applications/#{state.application_id}/guilds/#{guild_id}/commands"
    req(state, :get, path, nil, &decode_body_list/1)
  end

  def handle_call({:get_guild, guild_id, command_id}, _from, state) do
    path = "/applications/#{state.application_id}/guilds/#{guild_id}/commands/#{command_id}"
    req(state, :get, path, nil, &decode_body/1)
  end

  def handle_call({:edit_guild, guild_id, command_id, command}, _from, state) do
    path = "/applications/#{state.application_id}/guilds/#{guild_id}/commands/#{command_id}"
    req(state, :patch, path, encode_body(command), &decode_body/1)
  end

  def handle_call({:delete_guild, guild_id, command_id}, _from, state) do
    path = "/applications/#{state.application_id}/guilds/#{guild_id}/commands/#{command_id}"
    req(state, :delete, path, nil, fn _ -> :ok end)
  end

  def handle_call({:bulk_overwrite_guild, guild_id, commands}, _from, state) do
    path = "/applications/#{state.application_id}/guilds/#{guild_id}/commands"
    body = Enum.map(commands, &encode_body/1)
    req(state, :put, path, body, &decode_body_list/1)
  end

  # -- Helpers ---------------------------------------------------------------

  defp call(client_name, message) do
    GenServer.call(via_tuple(client_name), message)
  end

  defp via_tuple(client_name) do
    Module.concat(client_name, Rest)
  end

  defp ensure_base_url(%Req.Request{} = req) do
    if req.options[:base_url] do
      req
    else
      Req.merge(req, base_url: @base_url)
    end
  end

  defp fetch_application_id(http) do
    req =
      http
      |> Req.merge(method: :get, url: "/oauth2/applications/@me", decode_body: false)

    case Req.request(req) do
      {:ok, %{status: status, body: body}} when status in 200..299 ->
        case JSON.decode(body) do
          {:ok, %{"id" => id}} -> {:ok, id}
          {:ok, _} -> {:error, :missing_id_field}
          {:error, error} -> {:error, error}
        end

      {:ok, %{status: status}} ->
        {:error, {:http_error, status}}

      {:error, error} ->
        {:error, error}
    end
  end

  defp req(state, method, path, body, decode_fn) do
    req = state.http
    |> Req.merge(method: method, url: path, decode_body: false)

    req =
      if body do
        req
        |> Req.merge(
          body: JSON.encode!(body),
          headers: %{"content-type" => "application/json"}
        )
      else
        req
      end

    case Req.request(req) do
      {:ok, %{status: status, body: resp_body}} when status in 200..299 ->
        {:reply, decode_body(resp_body, decode_fn), state}

      {:ok, %{status: status, body: resp_body}} ->
        {:reply, {:error, %{status: status, body: decode_body_loose(resp_body)}}, state}

      {:error, exception} ->
        {:reply, {:error, exception}, state}
    end
  end

  defp encode_body(%ApplicationCommand{} = command) do
    Encodable.to_map(command)
  end

  defp encode_body(list) when is_list(list) do
    Enum.map(list, &Encodable.to_map/1)
  end

  defp decode_body("", _decode_fn), do: :ok

  defp decode_body(resp_body, decode_fn) do
    case JSON.decode(resp_body) do
      {:ok, decoded} -> decode_fn.(decoded)
      {:error, error} -> {:error, error}
    end
  end

  defp decode_body_loose(""), do: nil
  defp decode_body_loose(body) do
    case JSON.decode(body) do
      {:ok, decoded} -> decoded
      {:error, _} -> body
    end
  end

  defp decode_body(payload) when is_map(payload) do
    {:ok, ApplicationCommand.decode(payload)}
  end

  defp decode_body_list(payload) when is_list(payload) do
    {:ok, Enum.map(payload, &ApplicationCommand.decode/1)}
  end
end
