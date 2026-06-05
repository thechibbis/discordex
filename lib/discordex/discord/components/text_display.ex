defmodule Discordex.Discord.Components.TextDisplay do
  @moduledoc """
  Discord Text Display component.

  See: https://discord.com/developers/docs/interactions/message-components#text-display
  """

  @enforce_keys [:content]
  defstruct [:id, :content]

  @type t :: %__MODULE__{
    id: integer() | nil,
    content: String.t()
  }

  @spec new(String.t(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(content, opts \\ [])

  def new(content, opts) when is_binary(content) and is_list(opts) do
    {:ok,
     %__MODULE__{
       id: opts[:id],
       content: content
     }}
  end

  def new(_, _), do: {:error, :invalid_text_display}
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.TextDisplay do
  def to_map(display) do
    %{
      type: 10,
      content: display.content
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, display.id)
  end
end
