defmodule Discordex.Discord.Components.StringSelect do
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

  defp validate_custom_id(nil), do: :ok

  defp validate_custom_id(custom_id)
       when byte_size(custom_id) >= 1 and byte_size(custom_id) <= 100, do: :ok

  defp validate_custom_id(custom_id)
       when byte_size(custom_id) < 1 or byte_size(custom_id) > 100,
       do: {:error, :invalid_custom_id}

  defp validate_placeholder(nil), do: :ok
  defp validate_placeholder(placeholder) when byte_size(placeholder) <= 150, do: :ok
  defp validate_placeholder(_), do: {:error, :invalid_placeholder}

  defp validate_min_values(min_values)
  defp validate_min_values(min_values) when min_values >= 1 and min_values <= 25, do: :ok
  defp validate_min_values(_), do: {:error, :invalid_min_values}

  defp validate_max_values(nil), do: :ok
  defp validate_max_values(max_values) when max_values >= 1 and max_values <= 25, do: :ok
  defp validate_max_values(_), do: {:error, :invalid_max_values}

  defp validate_required(true, nil), do: {:error, :min_values_required_when_required_is_true}
  defp validate_required(_, _), do: :ok
end
