defmodule Discordex.Types.MessageInteractionMetadata do
  @moduledoc """
  Discord Message Interaction Metadata object.

  See: https://docs.discord.com/developers/resources/message#message-interaction-metadata-object
  """

  defstruct [
    :id,
    :type,
    :user_id,
    :authorizing_integration_owners,
    :original_response_message_id,
    :interacted_message_id,
    :triggering_interaction_metadata
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          type: integer() | nil,
          user_id: String.t() | nil,
          authorizing_integration_owners: map() | nil,
          original_response_message_id: String.t() | nil,
          interacted_message_id: String.t() | nil,
          triggering_interaction_metadata: map() | nil
        }

  @doc """
  Decodes a raw map into a MessageInteractionMetadata struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      type: payload["type"],
      user_id: payload["user_id"],
      authorizing_integration_owners: payload["authorizing_integration_owners"],
      original_response_message_id: payload["original_response_message_id"],
      interacted_message_id: payload["interacted_message_id"],
      triggering_interaction_metadata: payload["triggering_interaction_metadata"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.MessageInteractionMetadata do
  alias Discordex.Types.Encodable

  def to_map(metadata) do
    %{}
    |> Encodable.Helpers.maybe_put(:id, metadata.id)
    |> Encodable.Helpers.maybe_put(:type, metadata.type)
    |> Encodable.Helpers.maybe_put(:user_id, metadata.user_id)
    |> Encodable.Helpers.maybe_put(:authorizing_integration_owners, metadata.authorizing_integration_owners)
    |> Encodable.Helpers.maybe_put(:original_response_message_id, metadata.original_response_message_id)
    |> Encodable.Helpers.maybe_put(:interacted_message_id, metadata.interacted_message_id)
    |> Encodable.Helpers.maybe_put(:triggering_interaction_metadata, metadata.triggering_interaction_metadata)
  end
end
