defmodule Discordex.Discord.Components.Thumbnail do
  @moduledoc """
  Discord Thumbnail component.

  See: https://discord.com/developers/docs/interactions/message-components#thumbnail
  """

  alias Discordex.Discord.UnfurledMediaItem

  @enforce_keys [:media]
  defstruct [
    :id,
    :media,
    :description,
    spoiler: false
  ]

  @type t :: %__MODULE__{
    id: integer() | nil,
    media: UnfurledMediaItem.t(),
    description: String.t() | nil,
    spoiler: boolean()
  }

  @spec new(UnfurledMediaItem.t(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(media, opts \\ [])

  def new(media, opts) when is_list(opts) do
    with :ok <- validate_description(opts[:description]) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         media: media,
         description: opts[:description],
         spoiler: Keyword.get(opts, :spoiler, false)
       }}
    end
  end

  def new(_, _), do: {:error, :invalid_thumbnail}

  defp validate_description(nil), do: :ok
  defp validate_description(value) when is_binary(value) and byte_size(value) <= 1024, do: :ok
  defp validate_description(_), do: {:error, :invalid_description}
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.Thumbnail do
  def to_map(thumbnail) do
    %{
      type: 11,
      media: Discordex.Discord.Encodable.to_map(thumbnail.media),
      spoiler: thumbnail.spoiler
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, thumbnail.id)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:description, thumbnail.description)
  end
end
