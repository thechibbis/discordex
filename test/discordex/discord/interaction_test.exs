defmodule Discordex.Discord.InteractionTest do
  use ExUnit.Case, async: true

  alias Discordex.Discord.Interaction


  describe "decode/1" do
    test "decodes a minimal interaction payload" do
      payload = %{
        "id" => "123456789",
        "application_id" => "987654321",
        "type" => 2,
        "token" => "a-token",
        "version" => 1,
        "app_permissions" => "442368",
        "entitlements" => [],
        "authorizing_integration_owners" => %{},
        "attachment_size_limit" => 25_165_824
      }

      assert {:ok, interaction} = Interaction.decode(payload)
      assert interaction.id == "123456789"
      assert interaction.application_id == "987654321"
      assert interaction.type == :application_command
      assert interaction.token == "a-token"
      assert interaction.version == 1
      assert interaction.app_permissions == "442368"
      assert interaction.entitlements == []
      assert interaction.authorizing_integration_owners == %{}
      assert interaction.attachment_size_limit == 25_165_824
      assert interaction.data == nil
      assert interaction.guild == nil
      assert interaction.member == nil
      assert interaction.user == nil
      assert interaction.locale == nil
      assert interaction.context == nil
    end

    test "decodes all interaction types" do
      for {type_int, type_atom} <- [
            {1, :ping},
            {2, :application_command},
            {3, :message_component},
            {4, :application_command_autocomplete},
            {5, :modal_submit}
          ] do
        payload = base_payload(%{"type" => type_int})
        assert {:ok, %{type: ^type_atom}} = Interaction.decode(payload)
      end
    end

    test "decodes context type" do
      for {ctx_int, ctx_atom} <- [{0, :guild}, {1, :bot_dm}, {2, :private_channel}] do
        payload = base_payload(%{"context" => ctx_int})
        assert {:ok, %{context: ^ctx_atom}} = Interaction.decode(payload)
      end
    end

    test "decodes application command data" do
      payload =
        base_payload(%{
          "type" => 2,
          "data" => %{
            "id" => "cmd-id",
            "name" => "wave",
            "type" => 1,
            "guild_id" => "guild-123",
            "options" => [
              %{"name" => "target", "type" => 6, "value" => "user123"}
            ]
          }
        })

      assert {:ok, interaction} = Interaction.decode(payload)
      assert %Interaction.Data.ApplicationCommand{} = interaction.data
      assert interaction.data.id == "cmd-id"
      assert interaction.data.name == "wave"
      assert interaction.data.type == 1
      assert interaction.data.guild_id == "guild-123"
      assert length(interaction.data.options) == 1
      assert hd(interaction.data.options).name == "target"
    end

    test "decodes message component data" do
      payload =
        base_payload(%{
          "type" => 3,
          "data" => %{
            "custom_id" => "btn-1",
            "component_type" => 2,
            "values" => ["opt-a", "opt-b"]
          }
        })

      assert {:ok, interaction} = Interaction.decode(payload)
      assert %Interaction.Data.MessageComponent{} = interaction.data
      assert interaction.data.custom_id == "btn-1"
      assert interaction.data.component_type == 2
      assert interaction.data.values == ["opt-a", "opt-b"]
    end

    test "decodes modal submit data" do
      payload =
        base_payload(%{
          "type" => 5,
          "data" => %{
            "custom_id" => "modal-1",
            "components" => [%{"type" => 4, "custom_id" => "field-1", "value" => "hello"}]
          }
        })

      assert {:ok, interaction} = Interaction.decode(payload)
      assert %Interaction.Data.ModalSubmit{} = interaction.data
      assert interaction.data.custom_id == "modal-1"
      assert length(interaction.data.components) == 1
    end

    test "decodes resolved data" do
      payload =
        base_payload(%{
          "type" => 2,
          "data" => %{
            "id" => "cmd-id",
            "name" => "info",
            "type" => 1,
            "resolved" => %{
              "users" => %{"123" => %{"id" => "123", "username" => "test"}},
              "members" => %{"123" => %{"nick" => "TestUser"}},
              "channels" => %{"456" => %{"id" => "456", "name" => "general"}}
            }
          }
        })

      assert {:ok, interaction} = Interaction.decode(payload)
      assert interaction.data.resolved != nil
      assert interaction.data.resolved.users["123"].username == "test"
      assert interaction.data.resolved.members["123"].nick == "TestUser"
    end

    test "decodes nested types (user, member, guild, channel, message)" do
      payload =
        base_payload(%{
          "type" => 2,
          "user" => %{"id" => "u1", "username" => "alice", "discriminator" => "1234"},
          "member" => %{"nick" => "AliceNick", "roles" => ["role1"]},
          "guild" => %{"id" => "g1", "name" => "TestGuild", "features" => ["ANIMATED_ICON"]},
          "channel" => %{"id" => "c1", "name" => "general", "type" => 0},
          "message" => %{"id" => "m1", "content" => "hello", "channel_id" => "c1"}
        })

      assert {:ok, interaction} = Interaction.decode(payload)
      assert %Discordex.Discord.User{username: "alice"} = interaction.user
      assert %Discordex.Discord.GuildMember{nick: "AliceNick"} = interaction.member
      assert %Discordex.Discord.Guild{name: "TestGuild"} = interaction.guild
      assert %Discordex.Discord.Channel{name: "general"} = interaction.channel
      assert %Discordex.Discord.Message{content: "hello"} = interaction.message
    end

    test "decodes entitlements" do
      payload =
        base_payload(%{
          "entitlements" => [
            %{"id" => "e1", "sku_id" => "sku1", "application_id" => "app1", "type" => 1},
            %{"id" => "e2", "sku_id" => "sku2", "application_id" => "app2", "type" => 2}
          ]
        })

      assert {:ok, interaction} = Interaction.decode(payload)
      assert length(interaction.entitlements) == 2
      assert %Discordex.Discord.Entitlement{sku_id: "sku1"} = Enum.at(interaction.entitlements, 0)
      assert %Discordex.Discord.Entitlement{sku_id: "sku2"} = Enum.at(interaction.entitlements, 1)
    end

    test "returns error for invalid type" do
      payload = base_payload(%{"type" => 99})
      assert Interaction.decode(payload) == :error
    end

    test "returns error for non-map" do
      assert Interaction.decode("not a map") == {:error, :invalid_interaction_payload}
    end
  end

  describe "Encodable.to_map/1" do
    test "encodes interaction to Discord API map" do
      interaction = %Interaction{
        id: "123",
        application_id: "456",
        type: :application_command,
        token: "tok",
        version: 1,
        app_permissions: "0",
        entitlements: [],
        authorizing_integration_owners: %{},
        attachment_size_limit: 10_000_000
      }

      map = Discordex.Discord.Encodable.to_map(interaction)
      assert map.id == "123"
      assert map.application_id == "456"
      assert map.type == 2
      assert map.token == "tok"
      assert map.version == 1
      refute Map.has_key?(map, :data)
      refute Map.has_key?(map, :guild)
      refute Map.has_key?(map, :locale)
    end

    test "encodes optional fields when present" do
      interaction = %Interaction{
        id: "123",
        application_id: "456",
        type: :ping,
        token: "tok",
        version: 1,
        app_permissions: "0",
        entitlements: [],
        authorizing_integration_owners: %{},
        attachment_size_limit: 0,
        guild_id: "guild-1",
        locale: "en-US",
        context: :guild
      }

      map = Discordex.Discord.Encodable.to_map(interaction)
      assert map.guild_id == "guild-1"
      assert map.locale == "en-US"
      assert map.context == 0
    end

    test "encodes nested command data" do
      interaction = %Interaction{
        id: "123",
        application_id: "456",
        type: :application_command,
        token: "tok",
        version: 1,
        app_permissions: "0",
        entitlements: [],
        authorizing_integration_owners: %{},
        attachment_size_limit: 0,
        data: %Interaction.Data.ApplicationCommand{
          id: "cmd-1",
          name: "greet",
          type: 1
        }
      }

      map = Discordex.Discord.Encodable.to_map(interaction)
      assert map.data.id == "cmd-1"
      assert map.data.name == "greet"
      assert map.data.type == 1
    end

    test "encodes nested resource types (user, guild, entitlements)" do
      interaction = %Interaction{
        id: "123",
        application_id: "456",
        type: :application_command,
        token: "tok",
        version: 1,
        app_permissions: "0",
        entitlements: [
          %Discordex.Discord.Entitlement{id: "e1", sku_id: "sku1", application_id: "app1", type: 1}
        ],
        authorizing_integration_owners: %{},
        attachment_size_limit: 0,
        user: %Discordex.Discord.User{id: "u1", username: "testuser"},
        guild: %Discordex.Discord.Guild{id: "g1", name: "TestGuild"}
      }

      map = Discordex.Discord.Encodable.to_map(interaction)
      assert map.user.id == "u1"
      assert map.user.username == "testuser"
      assert map.guild.name == "TestGuild"
      assert is_list(map.entitlements)
      assert hd(map.entitlements).sku_id == "sku1"
    end

    test "round-trip: decode then encode is lossy but preserves key fields" do
      payload = %{
        "id" => "999",
        "application_id" => "888",
        "type" => 2,
        "token" => "round-trip-token",
        "version" => 1,
        "app_permissions" => "123",
        "entitlements" => [],
        "authorizing_integration_owners" => %{},
        "attachment_size_limit" => 5000,
        "locale" => "fr",
        "context" => 1
      }

      {:ok, decoded} = Interaction.decode(payload)
      encoded = Discordex.Discord.Encodable.to_map(decoded)

      assert encoded.id == "999"
      assert encoded.application_id == "888"
      assert encoded.type == 2
      assert encoded.token == "round-trip-token"
      assert encoded.version == 1
      assert encoded.locale == "fr"
      assert encoded.context == 1
    end
  end

  defp base_payload(overrides) do
    %{
      "id" => "123456789",
      "application_id" => "987654321",
      "type" => 1,
      "token" => "a-token",
      "version" => 1,
      "app_permissions" => "442368",
      "entitlements" => [],
      "authorizing_integration_owners" => %{},
      "attachment_size_limit" => 25_165_824
    }
    |> Map.merge(overrides)
  end
end
