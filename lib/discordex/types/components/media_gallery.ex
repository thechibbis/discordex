defmodule Discordex.Types.Components.MediaGallery do
  @moduledoc """
  Discord Media Gallery component.

  See: https://discord.com/developers/docs/interactions/message-components#media-gallery
  """

  alias Discordex.Types.Components.MediaGallery.Item

  @enforce_keys [:items]
  defstruct [:id, :items]

  @type t :: %__MODULE__{
    id: integer() | nil,
    items: [Item.t()]
  }

  @spec new([Item.t()], keyword()) :: {:ok, t()} | {:error, term()}
  def new(items, opts \\ [])

  def new(items, opts) when is_list(items) and is_list(opts) do
    with :ok <- validate_items(items) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         items: items
       }}
    end
  end

  def new(_, _), do: {:error, :invalid_media_gallery}

  defp validate_items([]), do: {:error, :empty_items}
  defp validate_items(items) when length(items) > 10, do: {:error, :too_many_items}
  defp validate_items(items) when is_list(items), do: :ok
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Components.MediaGallery do
  def to_map(gallery) do
    %{
      type: 12,
      items: Enum.map(gallery.items, &Discordex.Types.Encodable.to_map/1)
    }
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, gallery.id)
  end
end
