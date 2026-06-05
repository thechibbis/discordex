defmodule Discordex.Types.Components.ComponentType do
  @moduledoc """
  Discord message/modal component type.

  See: https://discord.com/developers/docs/components/reference#what-is-a-component
  """

  @type t ::
          :action_row
          | :button
          | :string_select
          | :text_input
          | :user_select
          | :role_select
          | :mentionable_select
          | :channel_select
          | :section
          | :text_display
          | :thumbnail
          | :media_gallery
          | :file
          | :separator
          | :container
          | :label

  @spec encode(t()) :: pos_integer()
  def encode(:action_row), do: 1
  def encode(:button), do: 2
  def encode(:string_select), do: 3
  def encode(:text_input), do: 4
  def encode(:user_select), do: 5
  def encode(:role_select), do: 6
  def encode(:mentionable_select), do: 7
  def encode(:channel_select), do: 8
  def encode(:section), do: 9
  def encode(:text_display), do: 10
  def encode(:thumbnail), do: 11
  def encode(:media_gallery), do: 12
  def encode(:file), do: 13
  def encode(:separator), do: 14
  def encode(:container), do: 17
  def encode(:label), do: 18

  @spec decode(integer()) :: {:ok, t()} | :error
  def decode(1), do: {:ok, :action_row}
  def decode(2), do: {:ok, :button}
  def decode(3), do: {:ok, :string_select}
  def decode(4), do: {:ok, :text_input}
  def decode(5), do: {:ok, :user_select}
  def decode(6), do: {:ok, :role_select}
  def decode(7), do: {:ok, :mentionable_select}
  def decode(8), do: {:ok, :channel_select}
  def decode(9), do: {:ok, :section}
  def decode(10), do: {:ok, :text_display}
  def decode(11), do: {:ok, :thumbnail}
  def decode(12), do: {:ok, :media_gallery}
  def decode(13), do: {:ok, :file}
  def decode(14), do: {:ok, :separator}
  def decode(17), do: {:ok, :container}
  def decode(18), do: {:ok, :label}
  def decode(_), do: :error
end
