defmodule Discordex.Types.ApplicationCommand.OptionType do
  @moduledoc """
  Discord application command option type.

  See: https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-type
  """

  @type t :: :sub_command | :sub_command_group | :string | :integer | :boolean | :user | :channel | :role | :mentionable | :number | :attachment

  @spec encode(t()) :: pos_integer()
  def encode(:sub_command), do: 1
  def encode(:sub_command_group), do: 2
  def encode(:string), do: 3
  def encode(:integer), do: 4
  def encode(:boolean), do: 5
  def encode(:user), do: 6
  def encode(:channel), do: 7
  def encode(:role), do: 8
  def encode(:mentionable), do: 9
  def encode(:number), do: 10
  def encode(:attachment), do: 11

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(1), do: {:ok, :sub_command}
  def decode(2), do: {:ok, :sub_command_group}
  def decode(3), do: {:ok, :string}
  def decode(4), do: {:ok, :integer}
  def decode(5), do: {:ok, :boolean}
  def decode(6), do: {:ok, :user}
  def decode(7), do: {:ok, :channel}
  def decode(8), do: {:ok, :role}
  def decode(9), do: {:ok, :mentionable}
  def decode(10), do: {:ok, :number}
  def decode(11), do: {:ok, :attachment}
  def decode(_), do: :error
end
