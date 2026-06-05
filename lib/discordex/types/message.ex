defmodule Discordex.Types.Message do
  @moduledoc """
  Discord Message object.

  In interactions, messages are included for component-triggered interactions.

  See: https://docs.discord.com/developers/resources/message#message-object
  """

  alias Discordex.Types.{
    Activity,
    ApplicationObject,
    Attachment,
    ChannelMention,
    Embed,
    MessageInteractionMetadata,
    MessageReference,
    Poll,
    RoleSubscriptionData,
    StickerItem,
    User
  }

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
          mention_channels: [ChannelMention.t()] | nil,
          attachments: [Attachment.t()] | nil,
          embeds: [Embed.t()] | nil,
          reactions: [map()] | nil,
          nonce: String.t() | integer() | nil,
          pinned: boolean() | nil,
          webhook_id: String.t() | nil,
          type: integer() | nil,
          activity: Activity.t() | nil,
          application: ApplicationObject.t() | nil,
          application_id: String.t() | nil,
          message_reference: MessageReference.t() | nil,
          flags: integer() | nil,
          referenced_message: map() | nil,
          interaction_metadata: MessageInteractionMetadata.t() | nil,
          thread: map() | nil,
          components: [map()] | nil,
          sticker_items: [StickerItem.t()] | nil,
          position: integer() | nil,
          role_subscription_data: RoleSubscriptionData.t() | nil,
          resolved: map() | nil,
          poll: Poll.t() | nil,
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
      mention_channels: decode_channel_mentions(payload["mention_channels"]),
      attachments: decode_attachments(payload["attachments"]),
      embeds: decode_embeds(payload["embeds"]),
      reactions: payload["reactions"],
      nonce: payload["nonce"],
      pinned: payload["pinned"],
      webhook_id: payload["webhook_id"],
      type: payload["type"],
      activity: decode_activity(payload["activity"]),
      application: decode_application(payload["application"]),
      application_id: payload["application_id"],
      message_reference: decode_message_reference(payload["message_reference"]),
      flags: payload["flags"],
      referenced_message: payload["referenced_message"],
      interaction_metadata: decode_interaction_metadata(payload["interaction_metadata"]),
      thread: payload["thread"],
      components: payload["components"],
      sticker_items: decode_sticker_items(payload["sticker_items"]),
      position: payload["position"],
      role_subscription_data: decode_role_subscription_data(payload["role_subscription_data"]),
      resolved: payload["resolved"],
      poll: decode_poll(payload["poll"]),
      purchase_notification: payload["purchase_notification"],
      call: payload["call"]
    }
  end

  defp decode_author(nil), do: nil
  defp decode_author(author_map), do: User.decode(author_map)

  defp decode_embeds(nil), do: nil
  defp decode_embeds(embeds) when is_list(embeds), do: Enum.map(embeds, &Embed.decode/1)

  defp decode_poll(nil), do: nil
  defp decode_poll(poll_map), do: Poll.decode(poll_map)

  defp decode_sticker_items(nil), do: nil
  defp decode_sticker_items(items) when is_list(items), do: Enum.map(items, &StickerItem.decode/1)

  defp decode_message_reference(nil), do: nil
  defp decode_message_reference(ref_map), do: MessageReference.decode(ref_map)

  defp decode_interaction_metadata(nil), do: nil
  defp decode_interaction_metadata(meta_map), do: MessageInteractionMetadata.decode(meta_map)

  defp decode_role_subscription_data(nil), do: nil
  defp decode_role_subscription_data(data_map), do: RoleSubscriptionData.decode(data_map)

  defp decode_application(nil), do: nil
  defp decode_application(app_map), do: ApplicationObject.decode(app_map)

  defp decode_activity(nil), do: nil
  defp decode_activity(activity_map), do: Activity.decode(activity_map)

  defp decode_channel_mentions(nil), do: nil
  defp decode_channel_mentions(mentions) when is_list(mentions), do: Enum.map(mentions, &ChannelMention.decode/1)

  defp decode_attachments(nil), do: nil
  defp decode_attachments(attachments) when is_list(attachments), do: Enum.map(attachments, &Attachment.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Message do
  alias Discordex.Types.Encodable.Helpers
  alias Discordex.Types.Encodable

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
    |> maybe_put_channel_mentions(message.mention_channels)
    |> maybe_put_attachments(message.attachments)
    |> maybe_put_embeds(message.embeds)
    |> Helpers.maybe_put(:reactions, message.reactions)
    |> Helpers.maybe_put(:nonce, message.nonce)
    |> Helpers.maybe_put(:pinned, message.pinned)
    |> Helpers.maybe_put(:webhook_id, message.webhook_id)
    |> Helpers.maybe_put(:type, message.type)
    |> maybe_put_activity(message.activity)
    |> maybe_put_application(message.application)
    |> Helpers.maybe_put(:application_id, message.application_id)
    |> maybe_put_message_reference(message.message_reference)
    |> Helpers.maybe_put(:flags, message.flags)
    |> Helpers.maybe_put(:referenced_message, message.referenced_message)
    |> maybe_put_interaction_metadata(message.interaction_metadata)
    |> Helpers.maybe_put(:thread, message.thread)
    |> Helpers.maybe_put(:components, message.components)
    |> maybe_put_sticker_items(message.sticker_items)
    |> Helpers.maybe_put(:position, message.position)
    |> maybe_put_role_subscription_data(message.role_subscription_data)
    |> Helpers.maybe_put(:resolved, message.resolved)
    |> maybe_put_poll(message.poll)
    |> Helpers.maybe_put(:purchase_notification, message.purchase_notification)
    |> Helpers.maybe_put(:call, message.call)
  end

  alias Discordex.Types.Encodable

  defp maybe_put_author(map, nil), do: map
  defp maybe_put_author(map, author), do: Map.put(map, :author, Encodable.to_map(author))

  defp maybe_put_attachments(map, nil), do: map
  defp maybe_put_attachments(map, attachments), do: Map.put(map, :attachments, Enum.map(attachments, &Encodable.to_map/1))

  defp maybe_put_embeds(map, nil), do: map
  defp maybe_put_embeds(map, embeds), do: Map.put(map, :embeds, Enum.map(embeds, &Encodable.to_map/1))

  defp maybe_put_channel_mentions(map, nil), do: map
  defp maybe_put_channel_mentions(map, mentions), do: Map.put(map, :mention_channels, Enum.map(mentions, &Encodable.to_map/1))

  defp maybe_put_activity(map, nil), do: map
  defp maybe_put_activity(map, activity), do: Map.put(map, :activity, Encodable.to_map(activity))

  defp maybe_put_application(map, nil), do: map
  defp maybe_put_application(map, app), do: Map.put(map, :application, Encodable.to_map(app))

  defp maybe_put_message_reference(map, nil), do: map
  defp maybe_put_message_reference(map, ref), do: Map.put(map, :message_reference, Encodable.to_map(ref))

  defp maybe_put_interaction_metadata(map, nil), do: map
  defp maybe_put_interaction_metadata(map, meta), do: Map.put(map, :interaction_metadata, Encodable.to_map(meta))

  defp maybe_put_sticker_items(map, nil), do: map
  defp maybe_put_sticker_items(map, items), do: Map.put(map, :sticker_items, Enum.map(items, &Encodable.to_map/1))

  defp maybe_put_role_subscription_data(map, nil), do: map
  defp maybe_put_role_subscription_data(map, data), do: Map.put(map, :role_subscription_data, Encodable.to_map(data))

  defp maybe_put_poll(map, nil), do: map
  defp maybe_put_poll(map, poll), do: Map.put(map, :poll, Encodable.to_map(poll))
end
