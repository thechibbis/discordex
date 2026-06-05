defmodule Discordex.Types.AuditLog do
  @moduledoc """
  Discord Audit Log object.

  See: https://docs.discord.com/developers/resources/audit-log#audit-log-object
  """

  alias Discordex.Types.AuditLog.Entry

  defstruct [
    :application_commands,
    :audit_log_entries,
    :auto_moderation_rules,
    :guild_scheduled_events,
    :integrations,
    :threads,
    :users,
    :webhooks
  ]

  @type t :: %__MODULE__{
    application_commands: [map()] | nil,
    audit_log_entries: [Entry.t()] | nil,
    auto_moderation_rules: [map()] | nil,
    guild_scheduled_events: [map()] | nil,
    integrations: [map()] | nil,
    threads: [map()] | nil,
    users: [map()] | nil,
    webhooks: [map()] | nil
  }

  @doc """
  Decodes a raw map into an AuditLog struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      application_commands: payload["application_commands"],
      audit_log_entries: decode_audit_log_entries(payload["audit_log_entries"]),
      auto_moderation_rules: payload["auto_moderation_rules"],
      guild_scheduled_events: payload["guild_scheduled_events"],
      integrations: payload["integrations"],
      threads: payload["threads"],
      users: payload["users"],
      webhooks: payload["webhooks"]
    }
  end

  defp decode_audit_log_entries(nil), do: nil
  defp decode_audit_log_entries(entries) when is_list(entries), do: Enum.map(entries, &Entry.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.AuditLog do
  alias Discordex.Types.Encodable

  def to_map(audit_log) do
    %{}
    |> Encodable.Helpers.maybe_put(:application_commands, audit_log.application_commands)
    |> maybe_put_audit_log_entries(audit_log.audit_log_entries)
    |> Encodable.Helpers.maybe_put(:auto_moderation_rules, audit_log.auto_moderation_rules)
    |> Encodable.Helpers.maybe_put(:guild_scheduled_events, audit_log.guild_scheduled_events)
    |> Encodable.Helpers.maybe_put(:integrations, audit_log.integrations)
    |> Encodable.Helpers.maybe_put(:threads, audit_log.threads)
    |> Encodable.Helpers.maybe_put(:users, audit_log.users)
    |> Encodable.Helpers.maybe_put(:webhooks, audit_log.webhooks)
  end

  defp maybe_put_audit_log_entries(map, nil), do: map
  defp maybe_put_audit_log_entries(map, entries), do: Map.put(map, :audit_log_entries, Enum.map(entries, &Encodable.to_map/1))
end
