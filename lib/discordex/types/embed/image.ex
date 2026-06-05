defmodule Discordex.Types.Embed.Image do
  @moduledoc """
  Discord Embed Image object.

  See: https://docs.discord.com/developers/resources/message#embed-object-embed-image-structure
  """

  @enforce_keys [:url]
  defstruct [
    :url,
    :proxy_url,
    :height,
    :width
  ]

  @type t :: %__MODULE__{
    url: String.t(),
    proxy_url: String.t() | nil,
    height: integer() | nil,
    width: integer() | nil
  }

  @doc """
  Decodes a raw map into an Image struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      url: payload["url"],
      proxy_url: payload["proxy_url"],
      height: payload["height"],
      width: payload["width"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Embed.Image do
  def to_map(image) do
    %{url: image.url}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:proxy_url, image.proxy_url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:height, image.height)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:width, image.width)
  end
end
