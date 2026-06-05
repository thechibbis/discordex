defmodule Discordex.Types.ChannelMention do
  @moduledoc """
  Discord Channel Mention object.

  See: https://docs.discord.com/developers/resources/channel#channel-mention-object
  """

  @enforce_keys [:id, :guild_id, :type, :name]
  defstruct [
    :id,
    :guild_id,
    :type,
    :name
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          guild_id: String.t(),
          type: integer(),
          name: String.t()
        }

  @doc """
  Decodes a raw map into a ChannelMention struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      guild_id: payload["guild_id"],
      type: payload["type"],
      name: payload["name"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.ChannelMention do
  def to_map(mention) do
    %{
      id: mention.id,
      guild_id: mention.guild_id,
      type: mention.type,
      name: mention.name
    }
  end
end
