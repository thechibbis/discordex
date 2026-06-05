defmodule Discordex.Types.Embed.Field do
  @moduledoc """
  Discord Embed Field object.

  See: https://docs.discord.com/developers/resources/message#embed-object-embed-field-structure
  """

  @enforce_keys [:name, :value, :inline]
  defstruct [
    :name,
    :value,
    :inline
  ]

  @type t :: %__MODULE__{
    name: String.t(),
    value: String.t(),
    inline: boolean()
  }

  @doc """
  Decodes a raw map into a Field struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      name: payload["name"],
      value: payload["value"],
      inline: payload["inline"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Embed.Field do
  def to_map(field) do
    %{
      name: field.name,
      value: field.value,
      inline: field.inline
    }
  end
end
