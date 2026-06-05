defmodule Discordex.Types.Poll.Media do
  @moduledoc """
  Discord Poll Media object.

  See: https://docs.discord.com/developers/resources/poll#poll-media-object
  """

  alias Discordex.Types.Emoji

  defstruct [
    :text,
    :emoji
  ]

  @type t :: %__MODULE__{
          text: String.t() | nil,
          emoji: Emoji.t() | nil
        }

  @doc """
  Decodes a raw map into a Poll.Media struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      text: payload["text"],
      emoji: decode_emoji(payload["emoji"])
    }
  end

  defp decode_emoji(nil), do: nil
  defp decode_emoji(emoji_map), do: Emoji.decode(emoji_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Poll.Media do
  alias Discordex.Types.Encodable

  def to_map(media) do
    %{}
    |> Encodable.Helpers.maybe_put(:text, media.text)
    |> maybe_put_emoji(media.emoji)
  end

  defp maybe_put_emoji(map, nil), do: map
  defp maybe_put_emoji(map, emoji), do: Map.put(map, :emoji, Encodable.to_map(emoji))
end
