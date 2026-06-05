defmodule Discordex.Types.Poll do
  @moduledoc """
  Discord Poll object.

  See: https://docs.discord.com/developers/resources/poll#poll-object
  """

  alias Discordex.Types.Poll.Media
  alias Discordex.Types.Poll.Answer
  alias Discordex.Types.Poll.Results

  defstruct [
    :question,
    :answers,
    :expiry,
    :allow_multiselect,
    :layout_type,
    :results
  ]

  @type t :: %__MODULE__{
          question: Media.t() | nil,
          answers: [Answer.t()] | nil,
          expiry: String.t() | nil,
          allow_multiselect: boolean() | nil,
          layout_type: integer() | nil,
          results: Results.t() | nil
        }

  @doc """
  Decodes a raw map into a Poll struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      question: decode_question(payload["question"]),
      answers: decode_answers(payload["answers"]),
      expiry: payload["expiry"],
      allow_multiselect: payload["allow_multiselect"],
      layout_type: payload["layout_type"],
      results: decode_results(payload["results"])
    }
  end

  defp decode_question(nil), do: nil
  defp decode_question(question_map), do: Media.decode(question_map)

  defp decode_answers(nil), do: nil
  defp decode_answers(answers_list), do: Enum.map(answers_list, &Answer.decode/1)

  defp decode_results(nil), do: nil
  defp decode_results(results_map), do: Results.decode(results_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Poll do
  alias Discordex.Types.Encodable

  def to_map(poll) do
    %{}
    |> Encodable.Helpers.maybe_put(:expiry, poll.expiry)
    |> Encodable.Helpers.maybe_put(:allow_multiselect, poll.allow_multiselect)
    |> Encodable.Helpers.maybe_put(:layout_type, poll.layout_type)
    |> maybe_put_question(poll.question)
    |> maybe_put_answers(poll.answers)
    |> maybe_put_results(poll.results)
  end

  defp maybe_put_question(map, nil), do: map
  defp maybe_put_question(map, question), do: Map.put(map, :question, Encodable.to_map(question))

  defp maybe_put_answers(map, nil), do: map
  defp maybe_put_answers(map, answers) do
    Map.put(map, :answers, Enum.map(answers, &Encodable.to_map/1))
  end

  defp maybe_put_results(map, nil), do: map
  defp maybe_put_results(map, results), do: Map.put(map, :results, Encodable.to_map(results))
end
