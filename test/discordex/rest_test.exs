defmodule Discordex.RestTest do
  use ExUnit.Case, async: true

  alias Discordex.Types.ApplicationCommand

  @app_id "123456789"
  @token "test-token"
  @client_name :test_client

  # Build a minimal valid ApplicationCommand for tests
  defp build_command(overrides \\ []) do
    defaults = [
      name: "ping",
      description: "Replies with pong",
      type: :chat_input
    ]

    struct!(ApplicationCommand, Keyword.merge(defaults, overrides))
  end

  # Build a Discord-style response map for a single command
  defp command_response(overrides \\ []) do
    defaults = %{
      "id" => "987654321",
      "application_id" => @app_id,
      "name" => "ping",
      "description" => "Replies with pong",
      "type" => 1,
      "version" => "1"
    }

    Map.merge(defaults, Map.new(overrides))
  end

  # -- Test helpers ---------------------------------------------------------

  defp start_rest(fake_adapter) do
    req = Req.new(adapter: fake_adapter, base_url: "https://discord.com/api/v10")

    start_supervised!(
      {Discordex.Rest,
       token: @token,
       application_id: @app_id,
       name: @client_name,
       req: req}
    )
  end

  # -- create_global_command -------------------------------------------------

  describe "create_global_command/2" do
    test "sends POST with encoded body and returns decoded command" do
      fake = fn request ->
        assert request.method == :post
        assert String.ends_with?(URI.to_string(request.url), "/applications/#{@app_id}/commands")

        # Body is JSON-encoded by our Rest module; decode to verify
        body = JSON.decode!(request.body)
        refute Map.has_key?(body, "handler")
        assert body["name"] == "ping"

        {request, Req.Response.new(status: 201, body: JSON.encode!(command_response()))}
      end

      start_rest(fake)

      command = build_command(handler: :my_handler)
      assert {:ok, %ApplicationCommand{name: "ping", id: "987654321"}} =
               Discordex.Rest.create_global_command(@client_name, command)
    end
  end

  # -- get_global_commands ---------------------------------------------------

  describe "get_global_commands/2" do
    test "sends GET and returns decoded list" do
      fake = fn request ->
        assert request.method == :get
        body = JSON.encode!([command_response(), command_response(%{"name" => "echo"})])
        {request, Req.Response.new(status: 200, body: body)}
      end

      start_rest(fake)

      assert {:ok, [%ApplicationCommand{name: "ping"}, %ApplicationCommand{name: "echo"}]} =
               Discordex.Rest.get_global_commands(@client_name)
    end
  end

  # -- get_global_command ----------------------------------------------------

  describe "get_global_command/2" do
    test "sends GET with command id in path" do
      fake = fn request ->
        assert String.ends_with?(URI.to_string(request.url), "/commands/999")
        body = JSON.encode!(command_response(%{"id" => "999"}))
        {request, Req.Response.new(status: 200, body: body)}
      end

      start_rest(fake)

      assert {:ok, %ApplicationCommand{id: "999"}} =
               Discordex.Rest.get_global_command(@client_name, "999")
    end
  end

  # -- edit_global_command ---------------------------------------------------

  describe "edit_global_command/3" do
    test "sends PATCH with encoded body" do
      fake = fn request ->
        assert request.method == :patch
        assert String.ends_with?(URI.to_string(request.url), "/commands/999")

        body = JSON.decode!(request.body)
        assert body["name"] == "updated"

        resp = JSON.encode!(command_response(%{"name" => "updated"}))
        {request, Req.Response.new(status: 200, body: resp)}
      end

      start_rest(fake)

      command = build_command(name: "updated")
      assert {:ok, %ApplicationCommand{name: "updated"}} =
               Discordex.Rest.edit_global_command(@client_name, "999", command)
    end
  end

  # -- delete_global_command -------------------------------------------------

  describe "delete_global_command/2" do
    test "sends DELETE and returns :ok" do
      fake = fn request ->
        assert request.method == :delete
        assert String.ends_with?(URI.to_string(request.url), "/commands/999")
        {request, Req.Response.new(status: 204, body: "")}
      end

      start_rest(fake)

      assert :ok = Discordex.Rest.delete_global_command(@client_name, "999")
    end
  end

  # -- bulk_overwrite_global_commands ----------------------------------------

  describe "bulk_overwrite_global_commands/2" do
    test "sends PUT with list of encoded commands" do
      fake = fn request ->
        assert request.method == :put
        body = JSON.decode!(request.body)
        assert is_list(body)
        assert length(body) == 2
        resp = JSON.encode!([command_response(), command_response()])
        {request, Req.Response.new(status: 200, body: resp)}
      end

      start_rest(fake)

      assert {:ok, commands} =
               Discordex.Rest.bulk_overwrite_global_commands(@client_name, [
                 build_command(),
                 build_command(name: "echo")
               ])

      assert length(commands) == 2
    end
  end

  # -- Guild command (spot-check one to verify guild path) -------------------

  describe "create_guild_command/3" do
    test "sends POST to guild-scoped path" do
      fake = fn request ->
        assert String.ends_with?(
                 URI.to_string(request.url),
                 "/applications/#{@app_id}/guilds/555/commands"
               )

        resp = JSON.encode!(command_response(%{"guild_id" => "555"}))
        {request, Req.Response.new(status: 201, body: resp)}
      end

      start_rest(fake)

      assert {:ok, %ApplicationCommand{guild_id: "555"}} =
               Discordex.Rest.create_guild_command(@client_name, "555", build_command())
    end
  end

  # -- delete_guild_command --------------------------------------------------

  describe "delete_guild_command/3" do
    test "sends DELETE to guild-scoped path with command id" do
      fake = fn request ->
        assert request.method == :delete
        assert String.ends_with?(
                 URI.to_string(request.url),
                 "/applications/#{@app_id}/guilds/555/commands/999"
               )

        {request, Req.Response.new(status: 204, body: "")}
      end

      start_rest(fake)

      assert :ok = Discordex.Rest.delete_guild_command(@client_name, "555", "999")
    end
  end

  # -- Error handling --------------------------------------------------------

  describe "error handling" do
    test "returns error tuple on non-2xx status" do
      fake = fn request ->
        body = JSON.encode!(%{"code" => 0, "message" => "401: Unauthorized"})
        {request, Req.Response.new(status: 401, body: body)}
      end

      start_rest(fake)

      assert {:error, %{status: 401, body: %{"message" => "401: Unauthorized"}}} =
               Discordex.Rest.get_global_commands(@client_name)
    end

    test "returns error tuple on transport error" do
      fake = fn request ->
        {request, %Mint.TransportError{reason: :econnrefused}}
      end

      start_rest(fake)

      assert {:error, %Mint.TransportError{}} =
               Discordex.Rest.get_global_commands(@client_name)
    end
  end
end
