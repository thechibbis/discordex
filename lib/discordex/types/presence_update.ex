defmodule Discordex.Types.PresenceUpdate do
  @moduledoc """
  Discord Presence Update object.

  A user's presence is their current state on a guild. Sent via Gateway,
  directly in response to Identify with `guild_subscriptions` enabled.

  See: https://docs.discord.com/developers/topics/gateway-events#presence-update
  """

  alias Discordex.Types.{User, Activity, ClientStatus}

  defstruct [
    :user,
    :guild_id,
    :status,
    :activities,
    :client_status
  ]

  @type t :: %__MODULE__{
          user: User.t() | nil,
          guild_id: String.t() | nil,
          status: String.t() | nil,
          activities: [Activity.t()] | nil,
          client_status: ClientStatus.t() | nil
        }

  @doc """
  Decodes a raw map into a PresenceUpdate struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      user: decode_user(payload["user"]),
      guild_id: payload["guild_id"],
      status: payload["status"],
      activities: decode_activities(payload["activities"]),
      client_status: decode_client_status(payload["client_status"])
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)

  defp decode_activities(nil), do: nil
  defp decode_activities(activities) when is_list(activities), do: Enum.map(activities, &Activity.decode/1)

  defp decode_client_status(nil), do: nil
  defp decode_client_status(client_status_map), do: ClientStatus.decode(client_status_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.PresenceUpdate do
  alias Discordex.Types.Encodable

  def to_map(presence) do
    %{}
    |> maybe_put_user(presence.user)
    |> Encodable.Helpers.maybe_put(:guild_id, presence.guild_id)
    |> Encodable.Helpers.maybe_put(:status, presence.status)
    |> maybe_put_activities(presence.activities)
    |> maybe_put_client_status(presence.client_status)
  end

  defp maybe_put_user(map, nil), do: map
  defp maybe_put_user(map, user), do: Map.put(map, :user, Encodable.to_map(user))

  defp maybe_put_activities(map, nil), do: map
  defp maybe_put_activities(map, activities), do: Map.put(map, :activities, Enum.map(activities, &Encodable.to_map/1))

  defp maybe_put_client_status(map, nil), do: map
  defp maybe_put_client_status(map, client_status), do: Map.put(map, :client_status, Encodable.to_map(client_status))
end
