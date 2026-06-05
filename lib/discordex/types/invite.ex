defmodule Discordex.Types.Invite do
  @moduledoc """
  Discord Invite object.

  See: https://docs.discord.com/developers/resources/invite#invite-object
  """

  alias Discordex.Types.User

  defstruct [
    :code,
    :guild,
    :channel,
    :inviter,
    :target_type,
    :target_user,
    :target_application,
    :approximate_presence_count,
    :approximate_member_count,
    :expires_at,
    :guild_scheduled_event
  ]

  @type t :: %__MODULE__{
          code: String.t() | nil,
          guild: map() | nil,
          channel: map() | nil,
          inviter: User.t() | nil,
          target_type: integer() | nil,
          target_user: User.t() | nil,
          target_application: map() | nil,
          approximate_presence_count: integer() | nil,
          approximate_member_count: integer() | nil,
          expires_at: String.t() | nil,
          guild_scheduled_event: map() | nil
        }

  @doc """
  Decodes a raw map into an Invite struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      code: payload["code"],
      guild: payload["guild"],
      channel: payload["channel"],
      inviter: decode_user(payload["inviter"]),
      target_type: payload["target_type"],
      target_user: decode_user(payload["target_user"]),
      target_application: payload["target_application"],
      approximate_presence_count: payload["approximate_presence_count"],
      approximate_member_count: payload["approximate_member_count"],
      expires_at: payload["expires_at"],
      guild_scheduled_event: payload["guild_scheduled_event"]
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Invite do
  alias Discordex.Types.Encodable

  def to_map(struct) do
    %{}
    |> Encodable.Helpers.maybe_put(:code, struct.code)
    |> Encodable.Helpers.maybe_put(:guild, struct.guild)
    |> Encodable.Helpers.maybe_put(:channel, struct.channel)
    |> maybe_put_inviter(struct.inviter)
    |> Encodable.Helpers.maybe_put(:target_type, struct.target_type)
    |> maybe_put_target_user(struct.target_user)
    |> Encodable.Helpers.maybe_put(:target_application, struct.target_application)
    |> Encodable.Helpers.maybe_put(:approximate_presence_count, struct.approximate_presence_count)
    |> Encodable.Helpers.maybe_put(:approximate_member_count, struct.approximate_member_count)
    |> Encodable.Helpers.maybe_put(:expires_at, struct.expires_at)
    |> Encodable.Helpers.maybe_put(:guild_scheduled_event, struct.guild_scheduled_event)
  end

  defp maybe_put_inviter(map, nil), do: map
  defp maybe_put_inviter(map, inviter), do: Map.put(map, :inviter, Encodable.to_map(inviter))

  defp maybe_put_target_user(map, nil), do: map
  defp maybe_put_target_user(map, target_user), do: Map.put(map, :target_user, Encodable.to_map(target_user))
end
