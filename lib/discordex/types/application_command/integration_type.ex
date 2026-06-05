defmodule Discordex.Types.ApplicationCommand.IntegrationType do
  @moduledoc """
  Discord application integration type.

  See: https://discord.com/developers/docs/resources/application#application-object-application-integration-types
  """

  @type t :: :guild_install | :user_install

  @spec encode(t()) :: non_neg_integer()
  def encode(:guild_install), do: 0
  def encode(:user_install), do: 1

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(0), do: {:ok, :guild_install}
  def decode(1), do: {:ok, :user_install}
  def decode(_), do: :error
end
