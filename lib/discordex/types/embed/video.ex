defmodule Discordex.Types.Embed.Video do
  @moduledoc """
  Discord Embed Video object.

  See: https://docs.discord.com/developers/resources/message#embed-object-embed-video-structure
  """

  defstruct [
    :url,
    :proxy_url,
    :height,
    :width
  ]

  @type t :: %__MODULE__{
    url: String.t() | nil,
    proxy_url: String.t() | nil,
    height: integer() | nil,
    width: integer() | nil
  }

  @doc """
  Decodes a raw map into a Video struct.
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

defimpl Discordex.Types.Encodable, for: Discordex.Types.Embed.Video do
  def to_map(video) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:url, video.url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:proxy_url, video.proxy_url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:height, video.height)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:width, video.width)
  end
end
