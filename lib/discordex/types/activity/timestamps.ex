defmodule Discordex.Types.Activity.Timestamps do
  @moduledoc """
  Activity Timestamps object.

  See: https://docs.discord.com/developers/resources/activity#activity-object-activity-timestamps
  """

  defstruct [
    :start,
    :end
  ]

  @type t :: %__MODULE__{
          start: integer() | nil,
          end: integer() | nil
        }

  @doc """
  Decodes a raw map into an Activity.Timestamps struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      start: payload["start"],
      end: payload["end"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Activity.Timestamps do
  alias Discordex.Types.Encodable

  def to_map(timestamps) do
    %{}
    |> Encodable.Helpers.maybe_put(:start, timestamps.start)
    |> Encodable.Helpers.maybe_put(:end, timestamps.end)
  end
end
