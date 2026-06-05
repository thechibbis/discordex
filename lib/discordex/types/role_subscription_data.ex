defmodule Discordex.Types.RoleSubscriptionData do
  @moduledoc """
  Discord Role Subscription Data object.

  See: https://docs.discord.com/developers/resources/message#role-subscription-data-object
  """

  defstruct [
    :role_subscription_listing_id,
    :tier_name,
    :total_months_subscribed,
    :is_renewal
  ]

  @type t :: %__MODULE__{
          role_subscription_listing_id: String.t() | nil,
          tier_name: String.t() | nil,
          total_months_subscribed: integer() | nil,
          is_renewal: boolean() | nil
        }

  @doc """
  Decodes a raw map into a RoleSubscriptionData struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      role_subscription_listing_id: payload["role_subscription_listing_id"],
      tier_name: payload["tier_name"],
      total_months_subscribed: payload["total_months_subscribed"],
      is_renewal: payload["is_renewal"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.RoleSubscriptionData do
  alias Discordex.Types.Encodable

  def to_map(data) do
    %{}
    |> Encodable.Helpers.maybe_put(:role_subscription_listing_id, data.role_subscription_listing_id)
    |> Encodable.Helpers.maybe_put(:tier_name, data.tier_name)
    |> Encodable.Helpers.maybe_put(:total_months_subscribed, data.total_months_subscribed)
    |> Encodable.Helpers.maybe_put(:is_renewal, data.is_renewal)
  end
end
