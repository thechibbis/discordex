defmodule Discordex.Types.Interaction.CallbackFlags do
  @moduledoc """
  Bitwise flags for interaction callback messages.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-interaction-callback-flags
  """

  @spec ephemeral() :: pos_integer()
  def ephemeral, do: 64

  @spec silent() :: pos_integer()
  def silent, do: 4096
end
