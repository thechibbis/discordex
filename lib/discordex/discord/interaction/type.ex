defmodule Discordex.Discord.Interaction.Type do
  @moduledoc """
  Discord interaction type.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-type
  """

  @type t :: :ping | :application_command | :message_component | :application_command_autocomplete | :modal_submit

  @spec encode(t()) :: pos_integer()
  def encode(:ping), do: 1
  def encode(:application_command), do: 2
  def encode(:message_component), do: 3
  def encode(:application_command_autocomplete), do: 4
  def encode(:modal_submit), do: 5

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(1), do: {:ok, :ping}
  def decode(2), do: {:ok, :application_command}
  def decode(3), do: {:ok, :message_component}
  def decode(4), do: {:ok, :application_command_autocomplete}
  def decode(5), do: {:ok, :modal_submit}
  def decode(_), do: :error
end
