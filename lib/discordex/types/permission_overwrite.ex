defmodule Discordex.Types.PermissionOverwrite do
  @moduledoc """
  Discord Permission Overwrite object.

  See: https://docs.discord.com/developers/resources/channel#overwrite-object
  """

  @enforce_keys [:id, :type, :allow, :deny]
  defstruct [
    :id,
    :type,
    :allow,
    :deny
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          type: integer(),
          allow: String.t(),
          deny: String.t()
        }

  @doc """
  Decodes a raw map into a PermissionOverwrite struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      type: payload["type"],
      allow: payload["allow"],
      deny: payload["deny"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.PermissionOverwrite do
  def to_map(overwrite) do
    %{
      id: overwrite.id,
      type: overwrite.type,
      allow: overwrite.allow,
      deny: overwrite.deny
    }
  end
end
