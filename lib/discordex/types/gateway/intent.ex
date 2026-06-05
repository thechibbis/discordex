defmodule Discordex.Types.Gateway.Intent do
  @moduledoc """
  Bitwise gateway intent constants for identifying event subscriptions.

  See: https://docs.discord.com/developers/topics/gateway#gateway-intents
  """

  @spec guilds() :: pos_integer()
  def guilds, do: 1

  @spec guild_members() :: pos_integer()
  def guild_members, do: 2

  @spec guild_moderation() :: pos_integer()
  def guild_moderation, do: 4

  @spec guild_emojis_and_stickers() :: pos_integer()
  def guild_emojis_and_stickers, do: 8

  @spec guild_integrations() :: pos_integer()
  def guild_integrations, do: 16

  @spec guild_webhooks() :: pos_integer()
  def guild_webhooks, do: 32

  @spec guild_invites() :: pos_integer()
  def guild_invites, do: 64

  @spec guild_voice_states() :: pos_integer()
  def guild_voice_states, do: 128

  @spec guild_presences() :: pos_integer()
  def guild_presences, do: 256

  @spec guild_messages() :: pos_integer()
  def guild_messages, do: 512

  @spec guild_message_reactions() :: pos_integer()
  def guild_message_reactions, do: 1024

  @spec guild_message_typing() :: pos_integer()
  def guild_message_typing, do: 2048

  @spec direct_messages() :: pos_integer()
  def direct_messages, do: 4096

  @spec direct_message_reactions() :: pos_integer()
  def direct_message_reactions, do: 8192

  @spec direct_message_typing() :: pos_integer()
  def direct_message_typing, do: 16384

  @spec message_content() :: pos_integer()
  def message_content, do: 32768

  @spec guild_scheduled_events() :: pos_integer()
  def guild_scheduled_events, do: 65536

  @spec auto_moderation_configuration() :: pos_integer()
  def auto_moderation_configuration, do: 1_048_576

  @spec auto_moderation_execution() :: pos_integer()
  def auto_moderation_execution, do: 2_097_152

  @spec guild_message_polls() :: pos_integer()
  def guild_message_polls, do: 16_777_216

  @spec direct_message_polls() :: pos_integer()
  def direct_message_polls, do: 33_554_432
end
