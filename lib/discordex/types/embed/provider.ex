defmodule Discordex.Types.Embed.Provider do
  @moduledoc """
  Discord Embed Provider object.

  See: https://docs.discord.com/developers/resources/message#embed-object-embed-provider-structure
  """

  defstruct [
    :name,
    :url
  ]

  @type t :: %__MODULE__{
    name: String.t() | nil,
    url: String.t() | nil
  }

  @doc """
  Decodes a raw map into a Provider struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      name: payload["name"],
      url: payload["url"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Embed.Provider do
  def to_map(provider) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:name, provider.name)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:url, provider.url)
  end
end
