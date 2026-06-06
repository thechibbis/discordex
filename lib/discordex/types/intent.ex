defmodule Discordex.Types.Intent do
  @moduledoc """
  Gateway intent atoms and their bitmask values.

  Each intent corresponds to a set of gateway events the client wishes
  to receive. Intents are combined with a bitwise OR when passed to the
  gateway identify payload.

  See: https://docs.discord.com/developers/topics/gateway#gateway-intents
  """

  @type t ::
          :guilds
          | :guild_members
          | :guild_moderation
          | :guild_emojis_and_stickers
          | :guild_integrations
          | :guild_webhooks
          | :guild_invites
          | :guild_voice_states
          | :guild_presences
          | :guild_messages
          | :guild_message_reactions
          | :guild_message_typing
          | :direct_messages
          | :direct_message_reactions
          | :direct_message_typing
          | :message_content
          | :guild_scheduled_events
          | :auto_moderation_configuration
          | :auto_moderation_execution
          | :guild_message_polls
          | :direct_message_polls

  @spec encode(t()) :: pos_integer()
  def encode(:guilds), do: 1
  def encode(:guild_members), do: 2
  def encode(:guild_moderation), do: 4
  def encode(:guild_emojis_and_stickers), do: 8
  def encode(:guild_integrations), do: 16
  def encode(:guild_webhooks), do: 32
  def encode(:guild_invites), do: 64
  def encode(:guild_voice_states), do: 128
  def encode(:guild_presences), do: 256
  def encode(:guild_messages), do: 512
  def encode(:guild_message_reactions), do: 1024
  def encode(:guild_message_typing), do: 2048
  def encode(:direct_messages), do: 4096
  def encode(:direct_message_reactions), do: 8192
  def encode(:direct_message_typing), do: 16_384
  def encode(:message_content), do: 32_768
  def encode(:guild_scheduled_events), do: 65_536
  def encode(:auto_moderation_configuration), do: 1_048_576
  def encode(:auto_moderation_execution), do: 2_097_152
  def encode(:guild_message_polls), do: 16_777_216
  def encode(:direct_message_polls), do: 33_554_432

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(1), do: {:ok, :guilds}
  def decode(2), do: {:ok, :guild_members}
  def decode(4), do: {:ok, :guild_moderation}
  def decode(8), do: {:ok, :guild_emojis_and_stickers}
  def decode(16), do: {:ok, :guild_integrations}
  def decode(32), do: {:ok, :guild_webhooks}
  def decode(64), do: {:ok, :guild_invites}
  def decode(128), do: {:ok, :guild_voice_states}
  def decode(256), do: {:ok, :guild_presences}
  def decode(512), do: {:ok, :guild_messages}
  def decode(1024), do: {:ok, :guild_message_reactions}
  def decode(2048), do: {:ok, :guild_message_typing}
  def decode(4096), do: {:ok, :direct_messages}
  def decode(8192), do: {:ok, :direct_message_reactions}
  def decode(16_384), do: {:ok, :direct_message_typing}
  def decode(32_768), do: {:ok, :message_content}
  def decode(65_536), do: {:ok, :guild_scheduled_events}
  def decode(1_048_576), do: {:ok, :auto_moderation_configuration}
  def decode(2_097_152), do: {:ok, :auto_moderation_execution}
  def decode(16_777_216), do: {:ok, :guild_message_polls}
  def decode(33_554_432), do: {:ok, :direct_message_polls}
  def decode(_), do: :error

  @doc """
  Combines a list of intent atoms into a single bitmask integer.

  ## Examples

      iex> to_bitmask([:guilds, :guild_messages])
      513
  """
  @spec to_bitmask([t()]) :: integer()
  def to_bitmask(intents) when is_list(intents) do
    Enum.reduce(intents, 0, fn intent, acc -> Bitwise.bor(acc, encode(intent)) end)
  end
end
