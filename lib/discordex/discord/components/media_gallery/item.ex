defmodule Discordex.Discord.Components.MediaGallery.Item do
  @moduledoc """
  An item within a Discord Media Gallery component.
  """

  alias Discordex.Discord.UnfurledMediaItem

  @enforce_keys [:media]
  defstruct [
    :media,
    :description,
    spoiler: false
  ]

  @type t :: %__MODULE__{
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
         media: media,
         description: opts[:description],
         spoiler: Keyword.get(opts, :spoiler, false)
       }}
    end
  end

  def new(_, _), do: {:error, :invalid_media_gallery_item}

  defp validate_description(nil), do: :ok
  defp validate_description(value) when is_binary(value) and byte_size(value) <= 1024, do: :ok
  defp validate_description(_), do: {:error, :invalid_description}
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.MediaGallery.Item do
  def to_map(item) do
    %{
      media: Discordex.Discord.Encodable.to_map(item.media),
      spoiler: item.spoiler
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:description, item.description)
  end
end
