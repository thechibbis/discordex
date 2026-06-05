defmodule Discordex.Types.Team do
  @moduledoc "Discord Team object."

  alias Discordex.Types.TeamMember

  defstruct [
    :icon,
    :id,
    :members,
    :name,
    :owner_user_id
  ]

  @type t :: %__MODULE__{
          icon: String.t() | nil,
          id: String.t() | nil,
          members: [TeamMember.t()] | nil,
          name: String.t() | nil,
          owner_user_id: String.t() | nil
        }

  @doc "Decodes a raw map into a Team struct."
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      icon: payload["icon"],
      id: payload["id"],
      members: decode_members(payload["members"]),
      name: payload["name"],
      owner_user_id: payload["owner_user_id"]
    }
  end

  defp decode_members(nil), do: nil
  defp decode_members(members) when is_list(members), do: Enum.map(members, &TeamMember.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Team do
  alias Discordex.Types.Encodable

  def to_map(team) do
    %{}
    |> Encodable.Helpers.maybe_put(:icon, team.icon)
    |> Encodable.Helpers.maybe_put(:id, team.id)
    |> maybe_put_members(team.members)
    |> Encodable.Helpers.maybe_put(:name, team.name)
    |> Encodable.Helpers.maybe_put(:owner_user_id, team.owner_user_id)
  end

  defp maybe_put_members(map, nil), do: map
  defp maybe_put_members(map, members), do: Map.put(map, :members, Enum.map(members, &Encodable.to_map/1))
end
