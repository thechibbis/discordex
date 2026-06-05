defmodule Discordex.Types.Components.StringSelect do
  @enforce_keys [:custom_id, :options]
  defstruct [
    :id,
    :custom_id,
    :options,
    :placeholder,
    min_values: 1,
    max_values: 1,
    required: true,
    disabled: false
  ]

  @type t :: %__MODULE__{
          id: integer() | nil,
          custom_id: String.t(),
          options: [StringSelect.Option.t()],
          placeholder: String.t() | nil,
          min_values: integer() | nil,
          max_values: integer() | nil,
          required: boolean(),
          disabled: boolean()
        }

  alias Discordex.Types.Components.StringSelect.Option

  @spec new(String.t(), [Option.t()], keyword()) :: {:ok, t()} | {:error, term()}
  def new(custom_id, options, opts \\ [])

  def new(custom_id, options, opts)
      when is_binary(custom_id) and is_list(options) and is_list(opts) do
    min_values = Keyword.get(opts, :min_values, 1)

    with :ok <- validate_custom_id(custom_id),
         :ok <- validate_options(options),
         :ok <- validate_placeholder(opts[:placeholder]),
         :ok <- validate_min_values(min_values),
         :ok <- validate_max_values(Keyword.get(opts, :max_values, 1)),
         :ok <- validate_required(Keyword.get(opts, :required, true), min_values) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         custom_id: custom_id,
         options: options,
         placeholder: opts[:placeholder],
         min_values: min_values,
         max_values: Keyword.get(opts, :max_values, 1),
         required: Keyword.get(opts, :required, true),
         disabled: Keyword.get(opts, :disabled, false)
       }}
    end
  end

  def new(_, _, _), do: {:error, :invalid_string_select}

  defp validate_options([]), do: {:error, :empty_options}
  defp validate_options(options) when is_list(options), do: :ok

  defp validate_custom_id(custom_id)
       when byte_size(custom_id) >= 1 and byte_size(custom_id) <= 100, do: :ok

  defp validate_custom_id(custom_id)
       when byte_size(custom_id) < 1 or byte_size(custom_id) > 100,
       do: {:error, :invalid_custom_id}

  defp validate_placeholder(nil), do: :ok
  defp validate_placeholder(placeholder) when byte_size(placeholder) <= 150, do: :ok
  defp validate_placeholder(_), do: {:error, :invalid_placeholder}

  defp validate_min_values(min_values) when min_values >= 1 and min_values <= 25, do: :ok
  defp validate_min_values(_), do: {:error, :invalid_min_values}

  defp validate_max_values(nil), do: :ok
  defp validate_max_values(max_values) when max_values >= 1 and max_values <= 25, do: :ok
  defp validate_max_values(_), do: {:error, :invalid_max_values}

  defp validate_required(true, nil), do: {:error, :min_values_required_when_required_is_true}
  defp validate_required(_, _), do: :ok
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Components.StringSelect do
  def to_map(select) do
    %{
      type: 3,
      custom_id: select.custom_id,
      options: Enum.map(select.options, &Discordex.Types.Encodable.to_map/1),
      min_values: select.min_values,
      max_values: select.max_values,
      disabled: select.disabled
    }
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, select.id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:placeholder, select.placeholder)
  end
end
