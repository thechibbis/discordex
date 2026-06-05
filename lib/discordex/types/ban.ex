defmodule Discordex.Types.Ban do
  @moduledoc """
  Discord Ban object.

  See: https://docs.discord.com/developers/resources/guild#ban-object
  """

  alias Discordex.Types.User

  defstruct [:reason, :user]

  @type t :: %__MODULE__{
          reason: String.t() | nil,
          user: User.t() | nil
        }

  @doc """
  Decodes a raw map into a Ban struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      reason: payload["reason"],
      user: decode_user(payload["user"])
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Ban do
  alias Discordex.Types.Encodable

  def to_map(ban) do
    %{}
    |> Encodable.Helpers.maybe_put(:reason, ban.reason)
    |> maybe_put_user(ban.user)
  end

  defp maybe_put_user(map, nil), do: map
  defp maybe_put_user(map, user), do: Map.put(map, :user, Encodable.to_map(user))
end
