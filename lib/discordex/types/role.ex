defmodule Discordex.Types.Role do
  @moduledoc """
  Discord Role object.

  See: https://docs.discord.com/developers/topics/permissions#role-object
  """

  defstruct [
    :id,
    :name,
    :color,
    :hoist,
    :icon,
    :unicode_emoji,
    :position,
    :permissions,
    :managed,
    :mentionable,
    :tags,
    :flags
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          color: integer() | nil,
          hoist: boolean() | nil,
          icon: String.t() | nil,
          unicode_emoji: String.t() | nil,
          position: integer() | nil,
          permissions: String.t() | nil,
          managed: boolean() | nil,
          mentionable: boolean() | nil,
          tags: map() | nil,
          flags: integer() | nil
        }

  @doc """
  Decodes a raw map into a Role struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      name: payload["name"],
      color: payload["color"],
      hoist: payload["hoist"],
      icon: payload["icon"],
      unicode_emoji: payload["unicode_emoji"],
      position: payload["position"],
      permissions: payload["permissions"],
      managed: payload["managed"],
      mentionable: payload["mentionable"],
      tags: payload["tags"],
      flags: payload["flags"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Role do
  def to_map(role) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, role.id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:name, role.name)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:color, role.color)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:hoist, role.hoist)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:icon, role.icon)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:unicode_emoji, role.unicode_emoji)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:position, role.position)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:permissions, role.permissions)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:managed, role.managed)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:mentionable, role.mentionable)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:tags, role.tags)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:flags, role.flags)
  end
end
