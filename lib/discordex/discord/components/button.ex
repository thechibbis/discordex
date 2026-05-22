defmodule Discordex.Discord.Components.Button do
  @moduledoc """
  Discord Button component.

  see: https://docs.discord.com/developers/components/reference#button
  """

  alias __MODULE__.{Interactive, Link, Premium}

  @opaque t :: Interactive.t() | Link.t() | Premium.t()

  @type interactive_style :: :primary | :secondary | :success | :danger

  @spec interactive(String.t(), interactive_style(), keyword()) ::
          {:ok, Interactive.t()} | {:error, term()}
  def interactive(custom_id, style, opts \\ []) do
    Interactive.new(custom_id, style, opts)
  end

  @spec link(String.t(), keyword()) ::
          {:ok, Link.t()} | {:error, term()}
  def link(url, opts \\ []) do
    Link.new(url, opts)
  end

  @spec premium(String.t(), keyword()) ::
          {:ok, Premium.t()} | {:error, term()}
  def premium(sku_id, opts \\ []) do
    Premium.new(sku_id, opts)
  end
end
