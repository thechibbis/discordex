defmodule Discordex.Discord.Channel do
  @moduledoc """
  Discord Channel object.

  In interactions, partial channels only include a subset of fields:
  `id`, `name`, `type`, `permissions`, `last_message_id`, `last_pin_timestamp`,
  `nsfw`, `parent_id`, `guild_id`, `flags`, `rate_limit_per_user`, `topic`,
  `position`, and `thread_metadata` for threads.

  See: https://docs.discord.com/developers/resources/channel#channel-object
  """

  defstruct [
    :id,
    :type,
    :guild_id,
    :position,
    :permission_overwrites,
    :name,
    :topic,
    :nsfw,
    :last_message_id,
    :bitrate,
    :user_limit,
    :rate_limit_per_user,
    :recipients,
    :icon,
    :owner_id,
    :application_id,
    :managed,
    :parent_id,
    :last_pin_timestamp,
    :rtc_region,
    :video_quality_mode,
    :message_count,
    :member_count,
    :thread_metadata,
    :member,
    :default_auto_archive_duration,
    :permissions,
    :flags,
    :total_message_sent,
    :available_tags,
    :applied_tags,
    :default_reaction_emoji,
    :default_thread_rate_limit_per_user,
    :default_sort_order,
    :default_forum_layout
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          type: integer() | nil,
          guild_id: String.t() | nil,
          position: integer() | nil,
          permission_overwrites: [map()] | nil,
          name: String.t() | nil,
          topic: String.t() | nil,
          nsfw: boolean() | nil,
          last_message_id: String.t() | nil,
          bitrate: integer() | nil,
          user_limit: integer() | nil,
          rate_limit_per_user: integer() | nil,
          recipients: [map()] | nil,
          icon: String.t() | nil,
          owner_id: String.t() | nil,
          application_id: String.t() | nil,
          managed: boolean() | nil,
          parent_id: String.t() | nil,
          last_pin_timestamp: String.t() | nil,
          rtc_region: String.t() | nil,
          video_quality_mode: integer() | nil,
          message_count: integer() | nil,
          member_count: integer() | nil,
          thread_metadata: map() | nil,
          member: map() | nil,
          default_auto_archive_duration: integer() | nil,
          permissions: String.t() | nil,
          flags: integer() | nil,
          total_message_sent: integer() | nil,
          available_tags: [map()] | nil,
          applied_tags: [String.t()] | nil,
          default_reaction_emoji: map() | nil,
          default_thread_rate_limit_per_user: integer() | nil,
          default_sort_order: integer() | nil,
          default_forum_layout: integer() | nil
        }

  @doc """
  Decodes a raw map into a Channel struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      type: payload["type"],
      guild_id: payload["guild_id"],
      position: payload["position"],
      permission_overwrites: payload["permission_overwrites"],
      name: payload["name"],
      topic: payload["topic"],
      nsfw: payload["nsfw"],
      last_message_id: payload["last_message_id"],
      bitrate: payload["bitrate"],
      user_limit: payload["user_limit"],
      rate_limit_per_user: payload["rate_limit_per_user"],
      recipients: payload["recipients"],
      icon: payload["icon"],
      owner_id: payload["owner_id"],
      application_id: payload["application_id"],
      managed: payload["managed"],
      parent_id: payload["parent_id"],
      last_pin_timestamp: payload["last_pin_timestamp"],
      rtc_region: payload["rtc_region"],
      video_quality_mode: payload["video_quality_mode"],
      message_count: payload["message_count"],
      member_count: payload["member_count"],
      thread_metadata: payload["thread_metadata"],
      member: payload["member"],
      default_auto_archive_duration: payload["default_auto_archive_duration"],
      permissions: payload["permissions"],
      flags: payload["flags"],
      total_message_sent: payload["total_message_sent"],
      available_tags: payload["available_tags"],
      applied_tags: payload["applied_tags"],
      default_reaction_emoji: payload["default_reaction_emoji"],
      default_thread_rate_limit_per_user: payload["default_thread_rate_limit_per_user"],
      default_sort_order: payload["default_sort_order"],
      default_forum_layout: payload["default_forum_layout"]
    }
  end
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Channel do
  alias Discordex.Discord.Encodable.Helpers

  def to_map(channel) do
    %{}
    |> Helpers.maybe_put(:id, channel.id)
    |> Helpers.maybe_put(:type, channel.type)
    |> Helpers.maybe_put(:guild_id, channel.guild_id)
    |> Helpers.maybe_put(:position, channel.position)
    |> Helpers.maybe_put(:permission_overwrites, channel.permission_overwrites)
    |> Helpers.maybe_put(:name, channel.name)
    |> Helpers.maybe_put(:topic, channel.topic)
    |> Helpers.maybe_put(:nsfw, channel.nsfw)
    |> Helpers.maybe_put(:last_message_id, channel.last_message_id)
    |> Helpers.maybe_put(:bitrate, channel.bitrate)
    |> Helpers.maybe_put(:user_limit, channel.user_limit)
    |> Helpers.maybe_put(:rate_limit_per_user, channel.rate_limit_per_user)
    |> Helpers.maybe_put(:recipients, channel.recipients)
    |> Helpers.maybe_put(:icon, channel.icon)
    |> Helpers.maybe_put(:owner_id, channel.owner_id)
    |> Helpers.maybe_put(:application_id, channel.application_id)
    |> Helpers.maybe_put(:managed, channel.managed)
    |> Helpers.maybe_put(:parent_id, channel.parent_id)
    |> Helpers.maybe_put(:last_pin_timestamp, channel.last_pin_timestamp)
    |> Helpers.maybe_put(:rtc_region, channel.rtc_region)
    |> Helpers.maybe_put(:video_quality_mode, channel.video_quality_mode)
    |> Helpers.maybe_put(:message_count, channel.message_count)
    |> Helpers.maybe_put(:member_count, channel.member_count)
    |> Helpers.maybe_put(:thread_metadata, channel.thread_metadata)
    |> Helpers.maybe_put(:member, channel.member)
    |> Helpers.maybe_put(:default_auto_archive_duration, channel.default_auto_archive_duration)
    |> Helpers.maybe_put(:permissions, channel.permissions)
    |> Helpers.maybe_put(:flags, channel.flags)
    |> Helpers.maybe_put(:total_message_sent, channel.total_message_sent)
    |> Helpers.maybe_put(:available_tags, channel.available_tags)
    |> Helpers.maybe_put(:applied_tags, channel.applied_tags)
    |> Helpers.maybe_put(:default_reaction_emoji, channel.default_reaction_emoji)
    |> Helpers.maybe_put(:default_thread_rate_limit_per_user, channel.default_thread_rate_limit_per_user)
    |> Helpers.maybe_put(:default_sort_order, channel.default_sort_order)
    |> Helpers.maybe_put(:default_forum_layout, channel.default_forum_layout)
  end
end
