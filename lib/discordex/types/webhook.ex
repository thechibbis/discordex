defmodule Discordex.Types.Webhook do
  @moduledoc "Discord Webhook object."

  alias Discordex.Types.User

  defstruct [
    :id,
    :type,
    :guild_id,
    :channel_id,
    :user,
    :name,
    :avatar,
    :token,
    :application_id,
    :source_guild,
    :source_channel,
    :url
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          type: integer() | nil,
          guild_id: String.t() | nil,
          channel_id: String.t() | nil,
          user: User.t() | nil,
          name: String.t() | nil,
          avatar: String.t() | nil,
          token: String.t() | nil,
          application_id: String.t() | nil,
          source_guild: map() | nil,
          source_channel: map() | nil,
          url: String.t() | nil
        }

  @doc "Decodes a raw map into a Webhook struct."
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      type: payload["type"],
      guild_id: payload["guild_id"],
      channel_id: payload["channel_id"],
      user: decode_user(payload["user"]),
      name: payload["name"],
      avatar: payload["avatar"],
      token: payload["token"],
      application_id: payload["application_id"],
      source_guild: payload["source_guild"],
      source_channel: payload["source_channel"],
      url: payload["url"]
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Webhook do
  alias Discordex.Types.Encodable

  def to_map(webhook) do
    %{}
    |> Encodable.Helpers.maybe_put(:id, webhook.id)
    |> Encodable.Helpers.maybe_put(:type, webhook.type)
    |> Encodable.Helpers.maybe_put(:guild_id, webhook.guild_id)
    |> Encodable.Helpers.maybe_put(:channel_id, webhook.channel_id)
    |> maybe_put_user(webhook.user)
    |> Encodable.Helpers.maybe_put(:name, webhook.name)
    |> Encodable.Helpers.maybe_put(:avatar, webhook.avatar)
    |> Encodable.Helpers.maybe_put(:token, webhook.token)
    |> Encodable.Helpers.maybe_put(:application_id, webhook.application_id)
    |> Encodable.Helpers.maybe_put(:source_guild, webhook.source_guild)
    |> Encodable.Helpers.maybe_put(:source_channel, webhook.source_channel)
    |> Encodable.Helpers.maybe_put(:url, webhook.url)
  end

  defp maybe_put_user(map, nil), do: map
  defp maybe_put_user(map, user), do: Map.put(map, :user, Encodable.to_map(user))
end
