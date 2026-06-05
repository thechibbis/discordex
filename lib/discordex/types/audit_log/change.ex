defmodule Discordex.Types.AuditLog.Change do
  @moduledoc """
  Discord Audit Log Change object.

  See: https://docs.discord.com/developers/resources/audit-log#audit-log-change-object
  """

  @enforce_keys [:key]
  defstruct [
    :new_value,
    :old_value,
    :key
  ]

  @type t :: %__MODULE__{
    new_value: any() | nil,
    old_value: any() | nil,
    key: String.t()
  }

  @doc """
  Decodes a raw map into an AuditLogChange struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      new_value: payload["new_value"],
      old_value: payload["old_value"],
      key: payload["key"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.AuditLog.Change do
  def to_map(change) do
    %{key: change.key}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:new_value, change.new_value)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:old_value, change.old_value)
  end
end
