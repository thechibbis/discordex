defmodule Discordex.Types.GuildScheduledEvent.EntityMetadata do
  @moduledoc """
  Discord Guild Scheduled Event Entity Metadata object.

  See: https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-entity-metadata
  """

  defstruct [
    :location,
    :speaker_ids
  ]

  @type t :: %__MODULE__{
    location: String.t() | nil,
    speaker_ids: [String.t()] | nil
  }

  @doc """
  Decodes a raw map into an EntityMetadata struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      location: payload["location"],
      speaker_ids: payload["speaker_ids"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.GuildScheduledEvent.EntityMetadata do
  def to_map(metadata) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:location, metadata.location)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:speaker_ids, metadata.speaker_ids)
  end
end
