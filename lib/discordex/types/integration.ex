defmodule Discordex.Types.Integration do
  @moduledoc """
  Discord Integration object.

  See: https://docs.discord.com/developers/resources/guild#integration-object
  """

  alias Discordex.Types.Integration.Account
  alias Discordex.Types.Integration.Application
  alias Discordex.Types.User

  @enforce_keys [:id, :name, :type, :enabled, :account]
  defstruct [
    :id,
    :name,
    :type,
    :enabled,
    :syncing,
    :role_id,
    :enable_emoticons,
    :expire_behavior,
    :expire_grace_period,
    :user,
    :account,
    :synced_at,
    :subscriber_count,
    :revoked,
    :application
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          type: String.t(),
          enabled: boolean(),
          syncing: boolean() | nil,
          role_id: String.t() | nil,
          enable_emoticons: boolean() | nil,
          expire_behavior: integer() | nil,
          expire_grace_period: integer() | nil,
          user: User.t() | nil,
          account: Account.t(),
          synced_at: String.t() | nil,
          subscriber_count: integer() | nil,
          revoked: boolean() | nil,
          application: Application.t() | nil
        }

  @doc """
  Decodes a raw map into an Integration struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      name: payload["name"],
      type: payload["type"],
      enabled: payload["enabled"],
      syncing: payload["syncing"],
      role_id: payload["role_id"],
      enable_emoticons: payload["enable_emoticons"],
      expire_behavior: payload["expire_behavior"],
      expire_grace_period: payload["expire_grace_period"],
      user: decode_user(payload["user"]),
      account: decode_account(payload["account"]),
      synced_at: payload["synced_at"],
      subscriber_count: payload["subscriber_count"],
      revoked: payload["revoked"],
      application: decode_application(payload["application"])
    }
  end

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)

  defp decode_account(nil), do: nil
  defp decode_account(account_map), do: Account.decode(account_map)

  defp decode_application(nil), do: nil
  defp decode_application(app_map), do: Application.decode(app_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Integration do
  alias Discordex.Types.Encodable

  def to_map(integration) do
    %{}
    |> Map.put(:id, integration.id)
    |> Map.put(:name, integration.name)
    |> Map.put(:type, integration.type)
    |> Map.put(:enabled, integration.enabled)
    |> Encodable.Helpers.maybe_put(:syncing, integration.syncing)
    |> Encodable.Helpers.maybe_put(:role_id, integration.role_id)
    |> Encodable.Helpers.maybe_put(:enable_emoticons, integration.enable_emoticons)
    |> Encodable.Helpers.maybe_put(:expire_behavior, integration.expire_behavior)
    |> Encodable.Helpers.maybe_put(:expire_grace_period, integration.expire_grace_period)
    |> maybe_put_user(integration.user)
    |> Map.put(:account, Encodable.to_map(integration.account))
    |> Encodable.Helpers.maybe_put(:synced_at, integration.synced_at)
    |> Encodable.Helpers.maybe_put(:subscriber_count, integration.subscriber_count)
    |> Encodable.Helpers.maybe_put(:revoked, integration.revoked)
    |> maybe_put_application(integration.application)
  end

  defp maybe_put_user(map, nil), do: map
  defp maybe_put_user(map, user), do: Map.put(map, :user, Encodable.to_map(user))

  defp maybe_put_application(map, nil), do: map
  defp maybe_put_application(map, app), do: Map.put(map, :application, Encodable.to_map(app))
end
