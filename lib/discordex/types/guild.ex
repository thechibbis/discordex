defmodule Discordex.Types.Guild do
  @moduledoc """
  Discord Guild object.

  Interactions include a partial guild with only: `id`, `name`, `icon`,
  `owner_id`, `permissions`, `features`, and optionally `approximate_member_count`
  and `approximate_presence_count`.

  See: https://docs.discord.com/developers/resources/guild#guild-object
  """

  alias Discordex.Types.Sticker

  defstruct [
    :id,
    :name,
    :icon,
    :icon_hash,
    :splash,
    :discovery_splash,
    :owner,
    :owner_id,
    :permissions,
    :region,
    :afk_channel_id,
    :afk_timeout,
    :widget_enabled,
    :widget_channel_id,
    :verification_level,
    :default_message_notifications,
    :explicit_content_filter,
    :roles,
    :emojis,
    :features,
    :mfa_level,
    :application_id,
    :system_channel_id,
    :system_channel_flags,
    :rules_channel_id,
    :max_presences,
    :max_members,
    :vanity_url_code,
    :description,
    :banner,
    :premium_tier,
    :premium_subscription_count,
    :preferred_locale,
    :public_updates_channel_id,
    :max_video_channel_users,
    :max_stage_video_channel_users,
    :approximate_member_count,
    :approximate_presence_count,
    :welcome_screen,
    :nsfw_level,
    :stickers,
    :premium_progress_bar_enabled,
    :safety_alerts_channel_id,
    :incidents_data
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          icon: String.t() | nil,
          icon_hash: String.t() | nil,
          splash: String.t() | nil,
          discovery_splash: String.t() | nil,
          owner: boolean() | nil,
          owner_id: String.t() | nil,
          permissions: String.t() | nil,
          region: String.t() | nil,
          afk_channel_id: String.t() | nil,
          afk_timeout: integer() | nil,
          widget_enabled: boolean() | nil,
          widget_channel_id: String.t() | nil,
          verification_level: integer() | nil,
          default_message_notifications: integer() | nil,
          explicit_content_filter: integer() | nil,
          roles: [map()] | nil,
          emojis: [map()] | nil,
          features: [String.t()] | nil,
          mfa_level: integer() | nil,
          application_id: String.t() | nil,
          system_channel_id: String.t() | nil,
          system_channel_flags: integer() | nil,
          rules_channel_id: String.t() | nil,
          max_presences: integer() | nil,
          max_members: integer() | nil,
          vanity_url_code: String.t() | nil,
          description: String.t() | nil,
          banner: String.t() | nil,
          premium_tier: integer() | nil,
          premium_subscription_count: integer() | nil,
          preferred_locale: String.t() | nil,
          public_updates_channel_id: String.t() | nil,
          max_video_channel_users: integer() | nil,
          max_stage_video_channel_users: integer() | nil,
          approximate_member_count: integer() | nil,
          approximate_presence_count: integer() | nil,
          welcome_screen: map() | nil,
          nsfw_level: integer() | nil,
          stickers: [Sticker.t()] | nil,
          premium_progress_bar_enabled: boolean() | nil,
          safety_alerts_channel_id: String.t() | nil,
          incidents_data: map() | nil
        }

  @doc """
  Decodes a raw map into a Guild struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      name: payload["name"],
      icon: payload["icon"],
      icon_hash: payload["icon_hash"],
      splash: payload["splash"],
      discovery_splash: payload["discovery_splash"],
      owner: payload["owner"],
      owner_id: payload["owner_id"],
      permissions: payload["permissions"],
      region: payload["region"],
      afk_channel_id: payload["afk_channel_id"],
      afk_timeout: payload["afk_timeout"],
      widget_enabled: payload["widget_enabled"],
      widget_channel_id: payload["widget_channel_id"],
      verification_level: payload["verification_level"],
      default_message_notifications: payload["default_message_notifications"],
      explicit_content_filter: payload["explicit_content_filter"],
      roles: payload["roles"],
      emojis: payload["emojis"],
      features: payload["features"],
      mfa_level: payload["mfa_level"],
      application_id: payload["application_id"],
      system_channel_id: payload["system_channel_id"],
      system_channel_flags: payload["system_channel_flags"],
      rules_channel_id: payload["rules_channel_id"],
      max_presences: payload["max_presences"],
      max_members: payload["max_members"],
      vanity_url_code: payload["vanity_url_code"],
      description: payload["description"],
      banner: payload["banner"],
      premium_tier: payload["premium_tier"],
      premium_subscription_count: payload["premium_subscription_count"],
      preferred_locale: payload["preferred_locale"],
      public_updates_channel_id: payload["public_updates_channel_id"],
      max_video_channel_users: payload["max_video_channel_users"],
      max_stage_video_channel_users: payload["max_stage_video_channel_users"],
      approximate_member_count: payload["approximate_member_count"],
      approximate_presence_count: payload["approximate_presence_count"],
      welcome_screen: payload["welcome_screen"],
      nsfw_level: payload["nsfw_level"],
      stickers: decode_stickers(payload["stickers"]),
      premium_progress_bar_enabled: payload["premium_progress_bar_enabled"],
      safety_alerts_channel_id: payload["safety_alerts_channel_id"],
      incidents_data: payload["incidents_data"]
    }
  end

  defp decode_stickers(nil), do: nil
  defp decode_stickers(stickers) when is_list(stickers), do: Enum.map(stickers, &Sticker.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Guild do
  alias Discordex.Types.Encodable.Helpers
  alias Discordex.Types.Encodable

  def to_map(guild) do
    %{}
    |> Helpers.maybe_put(:id, guild.id)
    |> Helpers.maybe_put(:name, guild.name)
    |> Helpers.maybe_put(:icon, guild.icon)
    |> Helpers.maybe_put(:icon_hash, guild.icon_hash)
    |> Helpers.maybe_put(:splash, guild.splash)
    |> Helpers.maybe_put(:discovery_splash, guild.discovery_splash)
    |> Helpers.maybe_put(:owner, guild.owner)
    |> Helpers.maybe_put(:owner_id, guild.owner_id)
    |> Helpers.maybe_put(:permissions, guild.permissions)
    |> Helpers.maybe_put(:region, guild.region)
    |> Helpers.maybe_put(:afk_channel_id, guild.afk_channel_id)
    |> Helpers.maybe_put(:afk_timeout, guild.afk_timeout)
    |> Helpers.maybe_put(:widget_enabled, guild.widget_enabled)
    |> Helpers.maybe_put(:widget_channel_id, guild.widget_channel_id)
    |> Helpers.maybe_put(:verification_level, guild.verification_level)
    |> Helpers.maybe_put(:default_message_notifications, guild.default_message_notifications)
    |> Helpers.maybe_put(:explicit_content_filter, guild.explicit_content_filter)
    |> Helpers.maybe_put(:roles, guild.roles)
    |> Helpers.maybe_put(:emojis, guild.emojis)
    |> Helpers.maybe_put(:features, guild.features)
    |> Helpers.maybe_put(:mfa_level, guild.mfa_level)
    |> Helpers.maybe_put(:application_id, guild.application_id)
    |> Helpers.maybe_put(:system_channel_id, guild.system_channel_id)
    |> Helpers.maybe_put(:system_channel_flags, guild.system_channel_flags)
    |> Helpers.maybe_put(:rules_channel_id, guild.rules_channel_id)
    |> Helpers.maybe_put(:max_presences, guild.max_presences)
    |> Helpers.maybe_put(:max_members, guild.max_members)
    |> Helpers.maybe_put(:vanity_url_code, guild.vanity_url_code)
    |> Helpers.maybe_put(:description, guild.description)
    |> Helpers.maybe_put(:banner, guild.banner)
    |> Helpers.maybe_put(:premium_tier, guild.premium_tier)
    |> Helpers.maybe_put(:premium_subscription_count, guild.premium_subscription_count)
    |> Helpers.maybe_put(:preferred_locale, guild.preferred_locale)
    |> Helpers.maybe_put(:public_updates_channel_id, guild.public_updates_channel_id)
    |> Helpers.maybe_put(:max_video_channel_users, guild.max_video_channel_users)
    |> Helpers.maybe_put(:max_stage_video_channel_users, guild.max_stage_video_channel_users)
    |> Helpers.maybe_put(:approximate_member_count, guild.approximate_member_count)
    |> Helpers.maybe_put(:approximate_presence_count, guild.approximate_presence_count)
    |> Helpers.maybe_put(:welcome_screen, guild.welcome_screen)
    |> Helpers.maybe_put(:nsfw_level, guild.nsfw_level)
    |> maybe_put_stickers(guild.stickers)
    |> Helpers.maybe_put(:premium_progress_bar_enabled, guild.premium_progress_bar_enabled)
    |> Helpers.maybe_put(:safety_alerts_channel_id, guild.safety_alerts_channel_id)
    |> Helpers.maybe_put(:incidents_data, guild.incidents_data)
  end

  defp maybe_put_stickers(map, nil), do: map
  defp maybe_put_stickers(map, stickers), do: Map.put(map, :stickers, Enum.map(stickers, &Encodable.to_map/1))
end
