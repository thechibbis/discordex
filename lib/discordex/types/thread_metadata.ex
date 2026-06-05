defmodule Discordex.Types.ThreadMetadata do
  @moduledoc """
  Discord Thread Metadata object.

  See: https://docs.discord.com/developers/resources/channel#thread-metadata-object
  """

  @enforce_keys [:archived, :auto_archive_duration, :archive_timestamp, :locked]
  defstruct [
    :archived,
    :auto_archive_duration,
    :archive_timestamp,
    :locked,
    :invitable,
    :create_timestamp
  ]

  @type t :: %__MODULE__{
          archived: boolean(),
          auto_archive_duration: integer(),
          archive_timestamp: String.t(),
          locked: boolean(),
          invitable: boolean() | nil,
          create_timestamp: String.t() | nil
        }

  @doc """
  Decodes a raw map into a ThreadMetadata struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      archived: payload["archived"],
      auto_archive_duration: payload["auto_archive_duration"],
      archive_timestamp: payload["archive_timestamp"],
      locked: payload["locked"],
      invitable: payload["invitable"],
      create_timestamp: payload["create_timestamp"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.ThreadMetadata do
  alias Discordex.Types.Encodable

  def to_map(metadata) do
    %{
      archived: metadata.archived,
      auto_archive_duration: metadata.auto_archive_duration,
      archive_timestamp: metadata.archive_timestamp,
      locked: metadata.locked
    }
    |> Encodable.Helpers.maybe_put(:invitable, metadata.invitable)
    |> Encodable.Helpers.maybe_put(:create_timestamp, metadata.create_timestamp)
  end
end
