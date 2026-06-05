defmodule Discordex.Discord.Message do
  @moduledoc """
  Discord Message object.

  In interactions, messages are included for component-triggered interactions.

  See: https://docs.discord.com/developers/resources/message#message-object
  """

  alias Discordex.Discord.User

  defstruct [
    :id,
    :channel_id,
    :author,
    :content,
    :timestamp,
    :edited_timestamp,
    :tts,
    :mention_everyone,
    :mentions,
    :mention_roles,
    :mention_channels,
    :attachments,
    :embeds,
    :reactions,
    :nonce,
    :pinned,
    :webhook_id,
    :type,
    :activity,
    :application,
    :application_id,
    :message_reference,
    :flags,
    :referenced_message,
    :interaction_metadata,
    :thread,
    :components,
    :sticker_items,
    :position,
    :role_subscription_data,
    :resolved,
    :poll,
    :purchase_notification,
    :call
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          channel_id: String.t() | nil,
          author: User.t() | nil,
          content: String.t() | nil,
          timestamp: String.t() | nil,
          edited_timestamp: String.t() | nil,
          tts: boolean() | nil,
          mention_everyone: boolean() | nil,
          mentions: [map()] | nil,
          mention_roles: [String.t()] | nil,
          mention_channels: [map()] | nil,
          attachments: [map()] | nil,
          embeds: [map()] | nil,
          reactions: [map()] | nil,
          nonce: String.t() | integer() | nil,
          pinned: boolean() | nil,
          webhook_id: String.t() | nil,
          type: integer() | nil,
          activity: map() | nil,
          application: map() | nil,
          application_id: String.t() | nil,
          message_reference: map() | nil,
          flags: integer() | nil,
          referenced_message: map() | nil,
          interaction_metadata: map() | nil,
          thread: map() | nil,
          components: [map()] | nil,
          sticker_items: [map()] | nil,
          position: integer() | nil,
          role_subscription_data: map() | nil,
          resolved: map() | nil,
          poll: map() | nil,
          purchase_notification: map() | nil,
          call: map() | nil
        }

  @doc """
  Decodes a raw map into a Message struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      channel_id: payload["channel_id"],
      author: decode_author(payload["author"]),
      content: payload["content"],
      timestamp: payload["timestamp"],
      edited_timestamp: payload["edited_timestamp"],
      tts: payload["tts"],
      mention_everyone: payload["mention_everyone"],
      mentions: payload["mentions"],
      mention_roles: payload["mention_roles"],
      mention_channels: payload["mention_channels"],
      attachments: payload["attachments"],
      embeds: payload["embeds"],
      reactions: payload["reactions"],
      nonce: payload["nonce"],
      pinned: payload["pinned"],
      webhook_id: payload["webhook_id"],
      type: payload["type"],
      activity: payload["activity"],
      application: payload["application"],
      application_id: payload["application_id"],
      message_reference: payload["message_reference"],
      flags: payload["flags"],
      referenced_message: payload["referenced_message"],
      interaction_metadata: payload["interaction_metadata"],
      thread: payload["thread"],
      components: payload["components"],
      sticker_items: payload["sticker_items"],
      position: payload["position"],
      role_subscription_data: payload["role_subscription_data"],
      resolved: payload["resolved"],
      poll: payload["poll"],
      purchase_notification: payload["purchase_notification"],
      call: payload["call"]
    }
  end

  defp decode_author(nil), do: nil
  defp decode_author(author_map), do: User.decode(author_map)
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Message do
  alias Discordex.Discord.Encodable.Helpers

  def to_map(message) do
    %{}
    |> Helpers.maybe_put(:id, message.id)
    |> Helpers.maybe_put(:channel_id, message.channel_id)
    |> maybe_put_author(message.author)
    |> Helpers.maybe_put(:content, message.content)
    |> Helpers.maybe_put(:timestamp, message.timestamp)
    |> Helpers.maybe_put(:edited_timestamp, message.edited_timestamp)
    |> Helpers.maybe_put(:tts, message.tts)
    |> Helpers.maybe_put(:mention_everyone, message.mention_everyone)
    |> Helpers.maybe_put(:mentions, message.mentions)
    |> Helpers.maybe_put(:mention_roles, message.mention_roles)
    |> Helpers.maybe_put(:mention_channels, message.mention_channels)
    |> Helpers.maybe_put(:attachments, message.attachments)
    |> Helpers.maybe_put(:embeds, message.embeds)
    |> Helpers.maybe_put(:reactions, message.reactions)
    |> Helpers.maybe_put(:nonce, message.nonce)
    |> Helpers.maybe_put(:pinned, message.pinned)
    |> Helpers.maybe_put(:webhook_id, message.webhook_id)
    |> Helpers.maybe_put(:type, message.type)
    |> Helpers.maybe_put(:activity, message.activity)
    |> Helpers.maybe_put(:application, message.application)
    |> Helpers.maybe_put(:application_id, message.application_id)
    |> Helpers.maybe_put(:message_reference, message.message_reference)
    |> Helpers.maybe_put(:flags, message.flags)
    |> Helpers.maybe_put(:referenced_message, message.referenced_message)
    |> Helpers.maybe_put(:interaction_metadata, message.interaction_metadata)
    |> Helpers.maybe_put(:thread, message.thread)
    |> Helpers.maybe_put(:components, message.components)
    |> Helpers.maybe_put(:sticker_items, message.sticker_items)
    |> Helpers.maybe_put(:position, message.position)
    |> Helpers.maybe_put(:role_subscription_data, message.role_subscription_data)
    |> Helpers.maybe_put(:resolved, message.resolved)
    |> Helpers.maybe_put(:poll, message.poll)
    |> Helpers.maybe_put(:purchase_notification, message.purchase_notification)
    |> Helpers.maybe_put(:call, message.call)
  end

  defp maybe_put_author(map, nil), do: map
  defp maybe_put_author(map, author) do
    Map.put(map, :author, Discordex.Discord.Encodable.to_map(author))
  end
end
