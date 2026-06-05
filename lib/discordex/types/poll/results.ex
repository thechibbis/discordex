defmodule Discordex.Types.Poll.Results do
  @moduledoc """
  Discord Poll Results object.

  See: https://docs.discord.com/developers/resources/poll#poll-results-object
  """

  alias Discordex.Types.Poll.AnswerCount

  defstruct [
    :is_finalized,
    :answer_counts
  ]

  @type t :: %__MODULE__{
          is_finalized: boolean() | nil,
          answer_counts: [AnswerCount.t()] | nil
        }

  @doc """
  Decodes a raw map into a Poll.Results struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      is_finalized: payload["is_finalized"],
      answer_counts: decode_answer_counts(payload["answer_counts"])
    }
  end

  defp decode_answer_counts(nil), do: nil
  defp decode_answer_counts(counts), do: Enum.map(counts, &AnswerCount.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Poll.Results do
  alias Discordex.Types.Encodable

  def to_map(results) do
    %{}
    |> Encodable.Helpers.maybe_put(:is_finalized, results.is_finalized)
    |> maybe_put_answer_counts(results.answer_counts)
  end

  defp maybe_put_answer_counts(map, nil), do: map
  defp maybe_put_answer_counts(map, counts) do
    Map.put(map, :answer_counts, Enum.map(counts, &Encodable.to_map/1))
  end
end
