defmodule Discordex.Types.AllowedMentions do
  @moduledoc """
  Discord Allowed Mentions object.

  See: https://docs.discord.com/developers/resources/message#allowed-mentions-object
  """

  defstruct [
    :parse,
    :roles,
    :users,
    :replied_user
  ]

  @type t :: %__MODULE__{
          parse: [String.t()] | nil,
          roles: [String.t()] | nil,
          users: [String.t()] | nil,
          replied_user: boolean() | nil
        }

  @doc """
  Decodes a raw map into an AllowedMentions struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      parse: payload["parse"],
      roles: payload["roles"],
      users: payload["users"],
      replied_user: payload["replied_user"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.AllowedMentions do
  alias Discordex.Types.Encodable

  def to_map(allowed_mentions) do
    %{}
    |> Encodable.Helpers.maybe_put(:parse, allowed_mentions.parse)
    |> Encodable.Helpers.maybe_put(:roles, allowed_mentions.roles)
    |> Encodable.Helpers.maybe_put(:users, allowed_mentions.users)
    |> Encodable.Helpers.maybe_put(:replied_user, allowed_mentions.replied_user)
  end
end
