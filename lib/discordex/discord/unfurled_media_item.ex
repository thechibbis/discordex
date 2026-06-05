defmodule Discordex.Discord.UnfurledMediaItem do
  @enforce_keys [:url]
  defstruct [:url]

  @type t :: %__MODULE__{
    url: String.t()
  }
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.UnfurledMediaItem do
  def to_map(media) do
    %{url: media.url}
  end
end
