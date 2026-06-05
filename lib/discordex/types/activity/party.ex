defmodule Discordex.Types.Activity.Party do
  @moduledoc """
  Activity Party object.

  See: https://docs.discord.com/developers/resources/activity#activity-object-activity-party
  """

  defstruct [
    :id,
    :size
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          size: [integer()] | nil
        }

  @doc """
  Decodes a raw map into an Activity.Party struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      size: payload["size"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Activity.Party do
  alias Discordex.Types.Encodable

  def to_map(party) do
    %{}
    |> Encodable.Helpers.maybe_put(:id, party.id)
    |> Encodable.Helpers.maybe_put(:size, party.size)
  end
end
