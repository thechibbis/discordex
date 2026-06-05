defmodule Discordex.Types.Embed.Thumbnail do
  @moduledoc """
  Discord Embed Thumbnail object.

  See: https://docs.discord.com/developers/resources/message#embed-object-embed-thumbnail-structure
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
  Decodes a raw map into a Thumbnail struct.
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

defimpl Discordex.Types.Encodable, for: Discordex.Types.Embed.Thumbnail do
  def to_map(thumbnail) do
    %{url: thumbnail.url}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:proxy_url, thumbnail.proxy_url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:height, thumbnail.height)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:width, thumbnail.width)
  end
end
