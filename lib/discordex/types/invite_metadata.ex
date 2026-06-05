defmodule Discordex.Types.InviteMetadata do
  @moduledoc """
  Discord Invite Metadata object.

  See: https://docs.discord.com/developers/resources/invite#invite-metadata-object
  """

  defstruct [
    :uses,
    :max_uses,
    :max_age,
    :temporary,
    :created_at
  ]

  @type t :: %__MODULE__{
          uses: integer() | nil,
          max_uses: integer() | nil,
          max_age: integer() | nil,
          temporary: boolean() | nil,
          created_at: String.t() | nil
        }

  @doc """
  Decodes a raw map into an InviteMetadata struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      uses: payload["uses"],
      max_uses: payload["max_uses"],
      max_age: payload["max_age"],
      temporary: payload["temporary"],
      created_at: payload["created_at"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.InviteMetadata do
  alias Discordex.Types.Encodable

  def to_map(struct) do
    %{}
    |> Encodable.Helpers.maybe_put(:uses, struct.uses)
    |> Encodable.Helpers.maybe_put(:max_uses, struct.max_uses)
    |> Encodable.Helpers.maybe_put(:max_age, struct.max_age)
    |> Encodable.Helpers.maybe_put(:temporary, struct.temporary)
    |> Encodable.Helpers.maybe_put(:created_at, struct.created_at)
  end
end
