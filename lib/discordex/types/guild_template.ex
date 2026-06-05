defmodule Discordex.Types.GuildTemplate do
  @moduledoc """
  Discord Guild Template object.

  See: https://docs.discord.com/developers/resources/guild-template#guild-template-object
  """

  alias Discordex.Types.User

  @enforce_keys [
    :code,
    :name,
    :usage_count,
    :creator_id,
    :creator,
    :created_at,
    :updated_at,
    :source_guild_id,
    :serialized_source_guild
  ]
  defstruct [
    :code,
    :name,
    :description,
    :usage_count,
    :creator_id,
    :creator,
    :created_at,
    :updated_at,
    :source_guild_id,
    :serialized_source_guild
  ]

  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          description: String.t() | nil,
          usage_count: integer(),
          creator_id: String.t(),
          creator: User.t(),
          created_at: String.t(),
          updated_at: String.t(),
          source_guild_id: String.t(),
          serialized_source_guild: map()
        }

  @doc """
  Decodes a raw map into a GuildTemplate struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      code: payload["code"],
      name: payload["name"],
      description: payload["description"],
      usage_count: payload["usage_count"],
      creator_id: payload["creator_id"],
      creator: decode_creator(payload["creator"]),
      created_at: payload["created_at"],
      updated_at: payload["updated_at"],
      source_guild_id: payload["source_guild_id"],
      serialized_source_guild: payload["serialized_source_guild"]
    }
  end

  defp decode_creator(nil), do: nil
  defp decode_creator(user_map), do: User.decode(user_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.GuildTemplate do
  alias Discordex.Types.Encodable

  def to_map(template) do
    %{}
    |> Map.put(:code, template.code)
    |> Map.put(:name, template.name)
    |> Encodable.Helpers.maybe_put(:description, template.description)
    |> Map.put(:usage_count, template.usage_count)
    |> Map.put(:creator_id, template.creator_id)
    |> Map.put(:creator, Encodable.to_map(template.creator))
    |> Map.put(:created_at, template.created_at)
    |> Map.put(:updated_at, template.updated_at)
    |> Map.put(:source_guild_id, template.source_guild_id)
    |> Map.put(:serialized_source_guild, template.serialized_source_guild)
  end
end
