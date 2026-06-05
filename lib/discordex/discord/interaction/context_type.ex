defmodule Discordex.Discord.Interaction.ContextType do
  @moduledoc """
  Discord interaction context type.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-context-types
  """

  @type t :: :guild | :bot_dm | :private_channel

  @spec encode(t()) :: pos_integer()
  def encode(:guild), do: 0
  def encode(:bot_dm), do: 1
  def encode(:private_channel), do: 2

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(0), do: {:ok, :guild}
  def decode(1), do: {:ok, :bot_dm}
  def decode(2), do: {:ok, :private_channel}
  def decode(_), do: :error
end
