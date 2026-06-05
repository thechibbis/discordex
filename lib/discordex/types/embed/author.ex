defmodule Discordex.Types.Embed.Author do
  @moduledoc """
  Discord Embed Author object.

  See: https://docs.discord.com/developers/resources/message#embed-object-embed-author-structure
  """

  @enforce_keys [:name]
  defstruct [
    :name,
    :url,
    :icon_url,
    :proxy_icon_url
  ]

  @type t :: %__MODULE__{
    name: String.t(),
    url: String.t() | nil,
    icon_url: String.t() | nil,
    proxy_icon_url: String.t() | nil
  }

  @doc """
  Decodes a raw map into an Author struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      name: payload["name"],
      url: payload["url"],
      icon_url: payload["icon_url"],
      proxy_icon_url: payload["proxy_icon_url"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Embed.Author do
  def to_map(author) do
    %{name: author.name}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:url, author.url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:icon_url, author.icon_url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:proxy_icon_url, author.proxy_icon_url)
  end
end
