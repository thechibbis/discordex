defmodule Discordex.Types.StickerItem do
  @moduledoc """
  Discord Sticker Item object.

  The smallest sticker object, used in messages to reference a sticker.

  See: https://docs.discord.com/developers/resources/sticker#sticker-item-object
  """

  @enforce_keys [:id, :name, :format_type]
  defstruct [:id, :name, :format_type]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          format_type: integer()
        }

  @doc """
  Decodes a raw map into a StickerItem struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      name: payload["name"],
      format_type: payload["format_type"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.StickerItem do
  def to_map(item) do
    %{
      id: item.id,
      name: item.name,
      format_type: item.format_type
    }
  end
end
