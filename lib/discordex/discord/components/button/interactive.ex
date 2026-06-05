defmodule Discordex.Discord.Components.Button.Interactive do
  alias Discordex.Discord.Components.Button

  @enforce_keys [:custom_id, :style]
  defstruct [
    :id,
    :custom_id,
    :style,
    :label,
    :emoji,
    disabled: false
  ]

  @type t :: %__MODULE__{
            id: integer() | nil,
            custom_id: String.t(),
            style: Button.interactive_style(),
            label: String.t() | nil,
            emoji: map() | nil,
            disabled: boolean()
          }

  @spec new(String.t(), Button.interactive_style(), keyword()) ::
          {:ok, t()} | {:error, term()}
  def new(custom_id, style, opts \\ [])

  def new(custom_id, style, opts)
      when is_binary(custom_id) and
             style in [:primary, :secondary, :success, :danger] and
             is_list(opts) do
    with :ok <- validate_custom_id(custom_id),
         :ok <- validate_label(opts[:label]) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         custom_id: custom_id,
         style: style,
         label: opts[:label],
         emoji: opts[:emoji],
         disabled: Keyword.get(opts, :disabled, false)
       }}
    end
  end

  def new(_custom_id, style, _opts) do
    {:error, {:invalid_interactive_button_style, style}}
  end

  defp validate_custom_id(value) when byte_size(value) in 1..100, do: :ok
  defp validate_custom_id(_), do: {:error, :invalid_custom_id}

  defp validate_label(nil), do: :ok
  defp validate_label(value) when is_binary(value) and byte_size(value) <= 80, do: :ok
  defp validate_label(_), do: {:error, :invalid_label}
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.Button.Interactive do
  def to_map(button) do
    %{
      type: 2,
      style: encode_style(button.style),
      custom_id: button.custom_id,
      disabled: button.disabled
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, button.id)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:label, button.label)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:emoji, button.emoji)
  end

  defp encode_style(:primary), do: 1
  defp encode_style(:secondary), do: 2
  defp encode_style(:success), do: 3
  defp encode_style(:danger), do: 4

end
