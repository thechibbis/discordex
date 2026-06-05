defmodule Discordex.Discord.NestedTypesTest do
  use ExUnit.Case, async: true

  alias Discordex.Discord.{User, GuildMember, Role, Channel, Guild, Message, Entitlement, Attachment}
  alias Discordex.Discord.Encodable

  describe "User" do
    test "decodes a full user payload" do
      payload = %{
        "id" => "123",
        "username" => "alice",
        "discriminator" => "5678",
        "global_name" => "Alice",
        "avatar" => "abc123",
        "bot" => false,
        "locale" => "en-US",
        "flags" => 64,
        "premium_type" => 2
      }

      user = User.decode(payload)
      assert %User{} = user
      assert user.id == "123"
      assert user.username == "alice"
      assert user.discriminator == "5678"
      assert user.global_name == "Alice"
      assert user.bot == false
      assert user.flags == 64
      assert user.premium_type == 2
    end

    test "handles missing optional fields" do
      user = User.decode(%{"id" => "1", "username" => "test"})
      assert user.id == "1"
      assert user.email == nil
      assert user.verified == nil
    end

    test "encodes to map and omits nil fields" do
      user = %User{id: "1", username: "alice"}
      map = Encodable.to_map(user)
      assert map.id == "1"
      assert map.username == "alice"
      refute Map.has_key?(map, :email)
      refute Map.has_key?(map, :banner)
    end
  end

  describe "GuildMember" do
    test "decodes member with nested user" do
      payload = %{
        "user" => %{"id" => "1", "username" => "bob"},
        "nick" => "Bobby",
        "roles" => ["role1", "role2"],
        "joined_at" => "2024-01-01T00:00:00Z",
        "deaf" => false,
        "mute" => false,
        "flags" => 0
      }

      member = GuildMember.decode(payload)
      assert %GuildMember{} = member
      assert member.nick == "Bobby"
      assert member.roles == ["role1", "role2"]
      assert %User{username: "bob"} = member.user
      assert member.deaf == false
    end

    test "handles missing user (partial member)" do
      member = GuildMember.decode(%{"nick" => "Partial", "roles" => []})
      assert member.nick == "Partial"
      assert member.user == nil
      assert member.deaf == nil
    end

    test "encodes nested user" do
      member = %GuildMember{
        nick: "Nick",
        user: %User{id: "1", username: "u"}
      }
      map = Encodable.to_map(member)
      assert map.nick == "Nick"
      assert map.user.username == "u"
    end
  end

  describe "Role" do
    test "decodes role payload" do
      role = Role.decode(%{
        "id" => "r1",
        "name" => "Admin",
        "color" => 16711680,
        "hoist" => true,
        "position" => 1,
        "permissions" => "8",
        "managed" => false,
        "mentionable" => true
      })

      assert %Role{} = role
      assert role.name == "Admin"
      assert role.color == 16711680
      assert role.hoist == true
      assert role.permissions == "8"
    end

    test "encodes role" do
      map = Encodable.to_map(%Role{id: "r1", name: "Mod"})
      assert map.id == "r1"
      assert map.name == "Mod"
      refute Map.has_key?(map, :color)
    end
  end

  describe "Channel" do
    test "decodes channel payload" do
      channel = Channel.decode(%{
        "id" => "c1",
        "type" => 0,
        "guild_id" => "g1",
        "name" => "general",
        "position" => 2,
        "nsfw" => false,
        "rate_limit_per_user" => 5
      })

      assert %Channel{} = channel
      assert channel.name == "general"
      assert channel.type == 0
      assert channel.rate_limit_per_user == 5
    end

    test "handles partial channel (missing many fields)" do
      channel = Channel.decode(%{"id" => "c1", "type" => 0})
      assert channel.id == "c1"
      assert channel.name == nil
    end
  end

  describe "Guild" do
    test "decodes partial guild payload" do
      guild = Guild.decode(%{
        "id" => "g1",
        "name" => "TestServer",
        "features" => ["ANIMATED_ICON", "COMMUNITY"],
        "approximate_member_count" => 100
      })

      assert %Guild{} = guild
      assert guild.name == "TestServer"
      assert guild.features == ["ANIMATED_ICON", "COMMUNITY"]
      assert guild.approximate_member_count == 100
    end
  end

  describe "Message" do
    test "decodes message with author" do
      message = Message.decode(%{
        "id" => "m1",
        "channel_id" => "c1",
        "author" => %{"id" => "u1", "username" => "author"},
        "content" => "hello world",
        "timestamp" => "2024-01-01T00:00:00Z",
        "pinned" => false,
        "type" => 0
      })

      assert %Message{} = message
      assert message.content == "hello world"
      assert %User{username: "author"} = message.author
    end

    test "handles message without author" do
      message = Message.decode(%{"id" => "m1", "channel_id" => "c1", "content" => "hi"})
      assert message.content == "hi"
      assert message.author == nil
    end

    test "encodes message with author" do
      message = %Message{
        id: "m1",
        channel_id: "c1",
        content: "test",
        author: %User{id: "u1", username: "a"}
      }
      map = Encodable.to_map(message)
      assert map.content == "test"
      assert map.author.username == "a"
    end
  end

  describe "Entitlement" do
    test "decodes entitlement" do
      entitlement = Entitlement.decode(%{
        "id" => "e1",
        "sku_id" => "sku1",
        "application_id" => "app1",
        "type" => 1,
        "deleted" => false
      })

      assert %Entitlement{} = entitlement
      assert entitlement.sku_id == "sku1"
      assert entitlement.deleted == false
    end

    test "defaults deleted to false when missing" do
      entitlement = Entitlement.decode(%{"id" => "e1", "sku_id" => "s1", "application_id" => "a1"})
      assert entitlement.deleted == false
    end
  end

  describe "Attachment" do
    test "decodes attachment" do
      attachment = Attachment.decode(%{
        "id" => "a1",
        "filename" => "image.png",
        "size" => 1024,
        "url" => "https://cdn.discord.com/attachments/a1/image.png",
        "proxy_url" => "https://media.discord.net/attachments/a1/image.png",
        "width" => 800,
        "height" => 600,
        "content_type" => "image/png"
      })

      assert %Attachment{} = attachment
      assert attachment.filename == "image.png"
      assert attachment.size == 1024
      assert attachment.width == 800
    end
  end

  describe "round-trips" do
    test "User decode → encode preserves key fields" do
      user = User.decode(%{"id" => "1", "username" => "alice", "discriminator" => "1234", "bot" => true})
      map = Encodable.to_map(user)
      assert map.id == "1"
      assert map.username == "alice"
      assert map.bot == true
    end

    test "Entitlement decode → encode" do
      entitlement = Entitlement.decode(%{"id" => "e1", "sku_id" => "s1", "application_id" => "a1", "type" => 1})
      map = Encodable.to_map(entitlement)
      assert map.sku_id == "s1"
      assert map.type == 1
    end
  end
end
