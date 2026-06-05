defmodule Discordex.Types.Emoji do
  @moduledoc """
  Discord Emoji object.

  See: https://docs.discord.com/developers/resources/emoji#emoji-object
  """

  alias Discordex.Types.User

  defstruct [
    :id,
    :name,
    :roles,
    :user,
    :require_colons,
    :managed,
    :animated,
    :available
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          roles: [String.t()] | nil,
          user: User.t() | nil,
          require_colons: boolean() | nil,
          managed: boolean() | nil,
          animated: boolean() | nil,
          available: boolean() | nil
        }

  @doc """
  Decodes a raw map into an Emoji struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      name: payload["name"],
      roles: payload["roles"],
      user: decode_user(payload["user"]),
      require_colons: payload["require_colons"],
      managed: payload["managed"],
      animated: payload["animated"],
      available: payload["available"]
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Emoji do
  alias Discordex.Types.Encodable

  def to_map(emoji) do
    %{}
    |> Encodable.Helpers.maybe_put(:id, emoji.id)
    |> Encodable.Helpers.maybe_put(:name, emoji.name)
    |> maybe_put_roles(emoji.roles)
    |> maybe_put_user(emoji.user)
    |> Encodable.Helpers.maybe_put(:require_colons, emoji.require_colons)
    |> Encodable.Helpers.maybe_put(:managed, emoji.managed)
    |> Encodable.Helpers.maybe_put(:animated, emoji.animated)
    |> Encodable.Helpers.maybe_put(:available, emoji.available)
  end

  defp maybe_put_roles(map, nil), do: map
  defp maybe_put_roles(map, roles), do: Map.put(map, :roles, roles)

  defp maybe_put_user(map, nil), do: map
  defp maybe_put_user(map, user), do: Map.put(map, :user, Encodable.to_map(user))
end