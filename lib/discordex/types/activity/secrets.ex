defmodule Discordex.Types.Activity.Secrets do
  @moduledoc """
  Activity Secrets object.

  See: https://docs.discord.com/developers/resources/activity#activity-object-activity-secrets
  """

  defstruct [
    :join,
    :spectate,
    :match
  ]

  @type t :: %__MODULE__{
          join: String.t() | nil,
          spectate: String.t() | nil,
          match: String.t() | nil
        }

  @doc """
  Decodes a raw map into an Activity.Secrets struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      join: payload["join"],
      spectate: payload["spectate"],
      match: payload["match"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Activity.Secrets do
  alias Discordex.Types.Encodable

  def to_map(secrets) do
    %{}
    |> Encodable.Helpers.maybe_put(:join, secrets.join)
    |> Encodable.Helpers.maybe_put(:spectate, secrets.spectate)
    |> Encodable.Helpers.maybe_put(:match, secrets.match)
  end
end
