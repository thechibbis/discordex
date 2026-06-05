defmodule Discordex.Discord.Components.TextInput do
  @moduledoc """
  Discord Text Input component.

  See: https://discord.com/developers/docs/interactions/message-components#text-input
  """

  @enforce_keys [:custom_id, :style]
  defstruct [
    :id,
    :custom_id,
    :style,
    :placeholder,
    :value,
    min_length: nil,
    max_length: nil,
    required: true
  ]

  @type style :: :short | :paragraph

  @type t :: %__MODULE__{
    id: integer() | nil,
    custom_id: String.t(),
    style: style(),
    placeholder: String.t() | nil,
    value: String.t() | nil,
    min_length: integer() | nil,
    max_length: integer() | nil,
    required: boolean()
  }

  @spec new(String.t(), style(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(custom_id, style, opts \\ [])

  def new(custom_id, style, opts) when is_binary(custom_id) and style in [:short, :paragraph] and is_list(opts) do
    with :ok <- validate_custom_id(custom_id),
         :ok <- validate_min_length(opts[:min_length]),
         :ok <- validate_max_length(opts[:max_length]),
         :ok <- validate_value(opts[:value]),
         :ok <- validate_placeholder(opts[:placeholder]) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         custom_id: custom_id,
         style: style,
         placeholder: opts[:placeholder],
         value: opts[:value],
         min_length: opts[:min_length],
         max_length: opts[:max_length],
         required: Keyword.get(opts, :required, true)
       }}
    end
  end

  def new(_, style, _), do: {:error, {:invalid_text_input_style, style}}

  defp validate_custom_id(value) when byte_size(value) in 1..100, do: :ok
  defp validate_custom_id(_), do: {:error, :invalid_custom_id}

  defp validate_min_length(nil), do: :ok
  defp validate_min_length(value) when is_integer(value) and value >= 0 and value <= 4000, do: :ok
  defp validate_min_length(_), do: {:error, :invalid_min_length}

  defp validate_max_length(nil), do: :ok
  defp validate_max_length(value) when is_integer(value) and value >= 1 and value <= 4000, do: :ok
  defp validate_max_length(_), do: {:error, :invalid_max_length}

  defp validate_value(nil), do: :ok
  defp validate_value(value) when is_binary(value) and byte_size(value) <= 4000, do: :ok
  defp validate_value(_), do: {:error, :invalid_value}

  defp validate_placeholder(nil), do: :ok
  defp validate_placeholder(value) when byte_size(value) <= 100, do: :ok
  defp validate_placeholder(_), do: {:error, :invalid_placeholder}
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.TextInput do
  def to_map(input) do
    %{
      type: 4,
      custom_id: input.custom_id,
      style: encode_style(input.style),
      required: input.required
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, input.id)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:min_length, input.min_length)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:max_length, input.max_length)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:value, input.value)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:placeholder, input.placeholder)
  end

  defp encode_style(:short), do: 1
  defp encode_style(:paragraph), do: 2
end
