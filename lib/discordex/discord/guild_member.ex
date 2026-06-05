defmodule Discordex.Discord.GuildMember do
  @moduledoc """
  Discord Guild Member object.

  In interactions, partial members omit `user`, `deaf`, and `mute` fields.

  See: https://docs.discord.com/developers/resources/guild#guild-member-object
  """

  alias Discordex.Discord.User

  defstruct [
    :user,
    :nick,
    :avatar,
    :roles,
    :joined_at,
    :premium_since,
    :deaf,
    :mute,
    :flags,
    :pending,
    :permissions,
    :communication_disabled_until
  ]

  @type t :: %__MODULE__{
          user: User.t() | nil,
          nick: String.t() | nil,
          avatar: String.t() | nil,
          roles: [String.t()] | nil,
          joined_at: String.t() | nil,
          premium_since: String.t() | nil,
          deaf: boolean() | nil,
          mute: boolean() | nil,
          flags: integer() | nil,
          pending: boolean() | nil,
          permissions: String.t() | nil,
          communication_disabled_until: String.t() | nil
        }

  @doc """
  Decodes a raw map into a GuildMember struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      user: decode_user(payload["user"]),
      nick: payload["nick"],
      avatar: payload["avatar"],
      roles: payload["roles"],
      joined_at: payload["joined_at"],
      premium_since: payload["premium_since"],
      deaf: payload["deaf"],
      mute: payload["mute"],
      flags: payload["flags"],
      pending: payload["pending"],
      permissions: payload["permissions"],
      communication_disabled_until: payload["communication_disabled_until"]
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.GuildMember do
  alias Discordex.Discord.Encodable.Helpers

  def to_map(member) do
    %{}
    |> maybe_put_user(member.user)
    |> Helpers.maybe_put(:nick, member.nick)
    |> Helpers.maybe_put(:avatar, member.avatar)
    |> Helpers.maybe_put(:roles, member.roles)
    |> Helpers.maybe_put(:joined_at, member.joined_at)
    |> Helpers.maybe_put(:premium_since, member.premium_since)
    |> Helpers.maybe_put(:deaf, member.deaf)
    |> Helpers.maybe_put(:mute, member.mute)
    |> Helpers.maybe_put(:flags, member.flags)
    |> Helpers.maybe_put(:pending, member.pending)
    |> Helpers.maybe_put(:permissions, member.permissions)
    |> Helpers.maybe_put(:communication_disabled_until, member.communication_disabled_until)
  end

  defp maybe_put_user(map, nil), do: map
  defp maybe_put_user(map, user) do
    Map.put(map, :user, Discordex.Discord.Encodable.to_map(user))
  end
end
