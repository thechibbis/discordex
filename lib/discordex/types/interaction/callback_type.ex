defmodule Discordex.Types.Interaction.CallbackType do
  @moduledoc """
  Discord interaction callback type.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-interaction-callback-type
  """

  @type t ::
          :pong
          | :channel_message_with_source
          | :deferred_channel_message_with_source
          | :deferred_update_message
          | :update_message
          | :application_command_autocomplete_result
          | :modal
          | :launch_activity

  @spec encode(t()) :: pos_integer()
  def encode(:pong), do: 1
  def encode(:channel_message_with_source), do: 4
  def encode(:deferred_channel_message_with_source), do: 5
  def encode(:deferred_update_message), do: 6
  def encode(:update_message), do: 7
  def encode(:application_command_autocomplete_result), do: 8
  def encode(:modal), do: 9
  def encode(:launch_activity), do: 12

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(1), do: {:ok, :pong}
  def decode(4), do: {:ok, :channel_message_with_source}
  def decode(5), do: {:ok, :deferred_channel_message_with_source}
  def decode(6), do: {:ok, :deferred_update_message}
  def decode(7), do: {:ok, :update_message}
  def decode(8), do: {:ok, :application_command_autocomplete_result}
  def decode(9), do: {:ok, :modal}
  def decode(12), do: {:ok, :launch_activity}
  def decode(_), do: :error
end
