defmodule Discordex.Types.Entitlement do
  @moduledoc """
  Discord Entitlement object, representing access to a premium SKU.

  See: https://docs.discord.com/developers/resources/entitlement#entitlement-object
  """

  defstruct [
    :id,
    :sku_id,
    :application_id,
    :user_id,
    :type,
    :deleted,
    :starts_at,
    :ends_at,
    :guild_id
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          sku_id: String.t() | nil,
          application_id: String.t() | nil,
          user_id: String.t() | nil,
          type: integer() | nil,
          deleted: boolean() | nil,
          starts_at: String.t() | nil,
          ends_at: String.t() | nil,
          guild_id: String.t() | nil
        }

  @doc """
  Decodes a raw map into an Entitlement struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      sku_id: payload["sku_id"],
      application_id: payload["application_id"],
      user_id: payload["user_id"],
      type: payload["type"],
      deleted: payload["deleted"] || false,
      starts_at: payload["starts_at"],
      ends_at: payload["ends_at"],
      guild_id: payload["guild_id"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Entitlement do
  def to_map(entitlement) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, entitlement.id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:sku_id, entitlement.sku_id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:application_id, entitlement.application_id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:user_id, entitlement.user_id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:type, entitlement.type)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:deleted, entitlement.deleted)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:starts_at, entitlement.starts_at)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:ends_at, entitlement.ends_at)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:guild_id, entitlement.guild_id)
  end
end
