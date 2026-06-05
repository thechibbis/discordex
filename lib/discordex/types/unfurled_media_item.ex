defmodule Discordex.Types.UnfurledMediaItem do
  @enforce_keys [:url]
  defstruct [:url]

  @type t :: %__MODULE__{
    url: String.t()
  }

  @doc """
  Decodes a raw map into an UnfurledMediaItem struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{url: payload["url"]}
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.UnfurledMediaItem do
  def to_map(media) do
    %{url: media.url}
  end
end
