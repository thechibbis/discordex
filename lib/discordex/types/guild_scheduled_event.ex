defmodule Discordex.Types.GuildScheduledEvent do
  @moduledoc """
  Discord Guild Scheduled Event object.

  See: https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-object
  """

  alias __MODULE__.EntityMetadata
  alias Discordex.Types.User

  defstruct [
    :id,
    :guild_id,
    :channel_id,
    :creator_id,
    :name,
    :description,
    :scheduled_start_time,
    :scheduled_end_time,
    :privacy_level,
    :status,
    :entity_type,
    :entity_id,
    :entity_metadata,
    :creator,
    :user_count,
    :image
  ]

  @type t :: %__MODULE__{
    id: String.t() | nil,
    guild_id: String.t() | nil,
    channel_id: String.t() | nil,
    creator_id: String.t() | nil,
    name: String.t() | nil,
    description: String.t() | nil,
    scheduled_start_time: String.t() | nil,
    scheduled_end_time: String.t() | nil,
    privacy_level: integer() | nil,
    status: integer() | nil,
    entity_type: integer() | nil,
    entity_id: String.t() | nil,
    entity_metadata: EntityMetadata.t() | nil,
    creator: User.t() | nil,
    user_count: integer() | nil,
    image: String.t() | nil
  }

  @doc """
  Decodes a raw map into a GuildScheduledEvent struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      guild_id: payload["guild_id"],
      channel_id: payload["channel_id"],
      creator_id: payload["creator_id"],
      name: payload["name"],
      description: payload["description"],
      scheduled_start_time: payload["scheduled_start_time"],
      scheduled_end_time: payload["scheduled_end_time"],
      privacy_level: payload["privacy_level"],
      status: payload["status"],
      entity_type: payload["entity_type"],
      entity_id: payload["entity_id"],
      entity_metadata: decode_entity_metadata(payload["entity_metadata"]),
      creator: decode_creator(payload["creator"]),
      user_count: payload["user_count"],
      image: payload["image"]
    }
  end

  defp decode_entity_metadata(nil), do: nil
  defp decode_entity_metadata(map), do: EntityMetadata.decode(map)

  defp decode_creator(nil), do: nil
  defp decode_creator(map), do: User.decode(map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.GuildScheduledEvent do
  alias Discordex.Types.Encodable

  def to_map(event) do
    %{}
    |> Encodable.Helpers.maybe_put(:id, event.id)
    |> Encodable.Helpers.maybe_put(:guild_id, event.guild_id)
    |> Encodable.Helpers.maybe_put(:channel_id, event.channel_id)
    |> Encodable.Helpers.maybe_put(:creator_id, event.creator_id)
    |> Encodable.Helpers.maybe_put(:name, event.name)
    |> Encodable.Helpers.maybe_put(:description, event.description)
    |> Encodable.Helpers.maybe_put(:scheduled_start_time, event.scheduled_start_time)
    |> Encodable.Helpers.maybe_put(:scheduled_end_time, event.scheduled_end_time)
    |> Encodable.Helpers.maybe_put(:privacy_level, event.privacy_level)
    |> Encodable.Helpers.maybe_put(:status, event.status)
    |> Encodable.Helpers.maybe_put(:entity_type, event.entity_type)
    |> Encodable.Helpers.maybe_put(:entity_id, event.entity_id)
    |> maybe_put_entity_metadata(event.entity_metadata)
    |> maybe_put_creator(event.creator)
    |> Encodable.Helpers.maybe_put(:user_count, event.user_count)
    |> Encodable.Helpers.maybe_put(:image, event.image)
  end

  defp maybe_put_entity_metadata(map, nil), do: map
  defp maybe_put_entity_metadata(map, metadata), do: Map.put(map, :entity_metadata, Encodable.to_map(metadata))

  defp maybe_put_creator(map, nil), do: map
  defp maybe_put_creator(map, creator), do: Map.put(map, :creator, Encodable.to_map(creator))
end
