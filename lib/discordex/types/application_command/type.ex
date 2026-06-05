defmodule Discordex.Types.ApplicationCommand.Type do
  @moduledoc """
  Discord application command type.

  See: https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-types
  """

  @type t :: :chat_input | :user | :message

  @spec encode(t()) :: pos_integer()
  def encode(:chat_input), do: 1
  def encode(:user), do: 2
  def encode(:message), do: 3

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(1), do: {:ok, :chat_input}
  def decode(2), do: {:ok, :user}
  def decode(3), do: {:ok, :message}
  def decode(_), do: :error
end
