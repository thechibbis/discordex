defmodule Discordex.Types.Sticker do
  @moduledoc """
  Discord Sticker object.

  Represents a sticker that can be sent in messages.

  See: https://docs.discord.com/developers/resources/sticker#sticker-object
  """

  alias Discordex.Types.User

  @enforce_keys [:id, :name, :type, :format_type]
  defstruct [
    :id,
    :pack_id,
    :name,
    :description,
    :tags,
    :asset,
    :type,
    :format_type,
    :available,
    :guild_id,
    :user,
    :sort_value
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          pack_id: String.t() | nil,
          name: String.t(),
          description: String.t() | nil,
          tags: String.t() | nil,
          asset: String.t() | nil,
          type: integer(),
          format_type: integer(),
          available: boolean() | nil,
          guild_id: String.t() | nil,
          user: User.t() | nil,
          sort_value: integer() | nil
        }

  @doc """
  Decodes a raw map into a Sticker struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      pack_id: payload["pack_id"],
      name: payload["name"],
      description: payload["description"],
      tags: payload["tags"],
      asset: payload["asset"],
      type: payload["type"],
      format_type: payload["format_type"],
      available: payload["available"],
      guild_id: payload["guild_id"],
      user: decode_user(payload["user"]),
      sort_value: payload["sort_value"]
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Sticker do
  alias Discordex.Types.Encodable.Helpers
  alias Discordex.Types.Encodable

  def to_map(sticker) do
    %{
      id: sticker.id,
      name: sticker.name,
      type: sticker.type,
      format_type: sticker.format_type
    }
    |> Helpers.maybe_put(:pack_id, sticker.pack_id)
    |> Helpers.maybe_put(:description, sticker.description)
    |> Helpers.maybe_put(:tags, sticker.tags)
    |> Helpers.maybe_put(:asset, sticker.asset)
    |> Helpers.maybe_put(:available, sticker.available)
    |> Helpers.maybe_put(:guild_id, sticker.guild_id)
    |> maybe_put_user(sticker.user)
    |> Helpers.maybe_put(:sort_value, sticker.sort_value)
  end

  defp maybe_put_user(map, nil), do: map
  defp maybe_put_user(map, user), do: Map.put(map, :user, Encodable.to_map(user))
end
