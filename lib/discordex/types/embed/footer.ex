defmodule Discordex.Types.Embed.Footer do
  @moduledoc """
  Discord Embed Footer object.

  See: https://docs.discord.com/developers/resources/message#embed-object-embed-footer-structure
  """

  @enforce_keys [:text]
  defstruct [
    :text,
    :icon_url,
    :proxy_icon_url
  ]

  @type t :: %__MODULE__{
    text: String.t(),
    icon_url: String.t() | nil,
    proxy_icon_url: String.t() | nil
  }

  @doc """
  Decodes a raw map into a Footer struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      text: payload["text"],
      icon_url: payload["icon_url"],
      proxy_icon_url: payload["proxy_icon_url"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Embed.Footer do
  def to_map(footer) do
    %{text: footer.text}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:icon_url, footer.icon_url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:proxy_icon_url, footer.proxy_icon_url)
  end
end
