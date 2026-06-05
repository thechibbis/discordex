defmodule Discordex.Types.Poll.Answer do
  @moduledoc """
  Discord Poll Answer object.

  See: https://docs.discord.com/developers/resources/poll#poll-answer-object
  """

  alias Discordex.Types.Poll.Media

  defstruct [
    :answer_id,
    :poll_media
  ]

  @type t :: %__MODULE__{
          answer_id: integer() | nil,
          poll_media: Media.t() | nil
        }

  @doc """
  Decodes a raw map into a Poll.Answer struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      answer_id: payload["answer_id"],
      poll_media: decode_poll_media(payload["poll_media"])
    }
  end

  defp decode_poll_media(nil), do: nil
  defp decode_poll_media(media_map), do: Media.decode(media_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Poll.Answer do
  alias Discordex.Types.Encodable

  def to_map(answer) do
    %{}
    |> Encodable.Helpers.maybe_put(:answer_id, answer.answer_id)
    |> maybe_put_poll_media(answer.poll_media)
  end

  defp maybe_put_poll_media(map, nil), do: map
  defp maybe_put_poll_media(map, media), do: Map.put(map, :poll_media, Encodable.to_map(media))
end
