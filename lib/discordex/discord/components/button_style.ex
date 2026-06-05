defmodule Discordex.Discord.Components.ButtonStyle do
  @type t ::
          :primary
          | :secondary
          | :success
          | :danger
          | :link
          | :premium

  @spec encode(t()) :: pos_integer()
  def encode(:primary), do: 1
  def encode(:secondary), do: 2
  def encode(:success), do: 3
  def encode(:danger), do: 4
  def encode(:link), do: 5
  def encode(:premium), do: 6

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(1), do: {:ok, :primary}
  def decode(2), do: {:ok, :secondary}
  def decode(3), do: {:ok, :success}
  def decode(4), do: {:ok, :danger}
  def decode(5), do: {:ok, :link}
  def decode(6), do: {:ok, :premium}
  def decode(_), do: :error
end