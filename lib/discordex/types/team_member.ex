defmodule Discordex.Types.TeamMember do
  @moduledoc "Discord Team Member object."

  alias Discordex.Types.User

  defstruct [
    :membership_state,
    :permissions,
    :team_id,
    :user,
    :role
  ]

  @type t :: %__MODULE__{
          membership_state: integer() | nil,
          permissions: [String.t()] | nil,
          team_id: String.t() | nil,
          user: User.t() | nil,
          role: String.t() | nil
        }

  @doc "Decodes a raw map into a TeamMember struct."
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      membership_state: payload["membership_state"],
      permissions: payload["permissions"],
      team_id: payload["team_id"],
      user: decode_user(payload["user"]),
      role: payload["role"]
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.TeamMember do
  alias Discordex.Types.Encodable

  def to_map(team_member) do
    %{}
    |> Encodable.Helpers.maybe_put(:membership_state, team_member.membership_state)
    |> Encodable.Helpers.maybe_put(:permissions, team_member.permissions)
    |> Encodable.Helpers.maybe_put(:team_id, team_member.team_id)
    |> maybe_put_user(team_member.user)
    |> Encodable.Helpers.maybe_put(:role, team_member.role)
  end

  defp maybe_put_user(map, nil), do: map
  defp maybe_put_user(map, user), do: Map.put(map, :user, Encodable.to_map(user))
end
