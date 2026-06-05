defmodule Discordex.Types.Poll.AnswerCount do
  @moduledoc """
  Discord Poll Answer Count object.

  See: https://docs.discord.com/developers/resources/poll#poll-results-object
  """

  defstruct [
    :id,
    :count,
    :me_voted
  ]

  @type t :: %__MODULE__{
          id: integer() | nil,
          count: integer() | nil,
          me_voted: boolean() | nil
        }

  @doc """
  Decodes a raw map into a Poll.AnswerCount struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      count: payload["count"],
      me_voted: payload["me_voted"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Poll.AnswerCount do
  alias Discordex.Types.Encodable

  def to_map(answer_count) do
    %{}
    |> Encodable.Helpers.maybe_put(:id, answer_count.id)
    |> Encodable.Helpers.maybe_put(:count, answer_count.count)
    |> Encodable.Helpers.maybe_put(:me_voted, answer_count.me_voted)
  end
end
