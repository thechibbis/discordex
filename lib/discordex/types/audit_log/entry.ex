defmodule Discordex.Types.AuditLog.Entry do
  @moduledoc """
  Discord Audit Log Entry object.

  See: https://docs.discord.com/developers/resources/audit-log#audit-log-entry-object
  """

  alias Discordex.Types.AuditLog.Change

  @enforce_keys [:id, :action_type]
  defstruct [
    :target_id,
    :changes,
    :user_id,
    :id,
    :action_type,
    :options,
    :reason
  ]

  @type t :: %__MODULE__{
    target_id: String.t() | nil,
    changes: [Change.t()] | nil,
    user_id: String.t() | nil,
    id: String.t(),
    action_type: integer(),
    options: map() | nil,
    reason: String.t() | nil
  }

  @doc """
  Decodes a raw map into an AuditLogEntry struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      target_id: payload["target_id"],
      changes: decode_changes(payload["changes"]),
      user_id: payload["user_id"],
      id: payload["id"],
      action_type: payload["action_type"],
      options: payload["options"],
      reason: payload["reason"]
    }
  end

  defp decode_changes(nil), do: nil
  defp decode_changes(changes) when is_list(changes), do: Enum.map(changes, &Change.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.AuditLog.Entry do
  alias Discordex.Types.Encodable

  def to_map(entry) do
    %{id: entry.id, action_type: entry.action_type}
    |> Encodable.Helpers.maybe_put(:target_id, entry.target_id)
    |> maybe_put_changes(entry.changes)
    |> Encodable.Helpers.maybe_put(:user_id, entry.user_id)
    |> Encodable.Helpers.maybe_put(:options, entry.options)
    |> Encodable.Helpers.maybe_put(:reason, entry.reason)
  end

  defp maybe_put_changes(map, nil), do: map
  defp maybe_put_changes(map, changes), do: Map.put(map, :changes, Enum.map(changes, &Encodable.to_map/1))
end
