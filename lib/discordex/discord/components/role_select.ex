defmodule Discordex.Discord.Components.RoleSelect do
  @moduledoc """
  Discord Role Select component.

  See: https://discord.com/developers/docs/interactions/message-components#role-select
  """

  alias Discordex.Discord.DefaultValue

  @enforce_keys [:custom_id]
  defstruct [
    :id,
    :custom_id,
    :placeholder,
    default_values: [],
    min_values: 1,
    max_values: 1,
    required: true,
    disabled: false
  ]

  @type t :: %__MODULE__{
    id: integer() | nil,
    custom_id: String.t(),
    placeholder: String.t() | nil,
    default_values: [DefaultValue.t()],
    min_values: integer(),
    max_values: integer(),
    required: boolean(),
    disabled: boolean()
  }

  @spec new(String.t(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(custom_id, opts \\ [])

  def new(custom_id, opts) when is_binary(custom_id) and is_list(opts) do
    min_values = Keyword.get(opts, :min_values, 1)

    with :ok <- validate_custom_id(custom_id),
         :ok <- validate_placeholder(opts[:placeholder]),
         :ok <- validate_default_values(opts[:default_values]),
         :ok <- validate_min_values(min_values),
         :ok <- validate_max_values(Keyword.get(opts, :max_values, 1)),
         :ok <- validate_required(Keyword.get(opts, :required, true), min_values) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         custom_id: custom_id,
         placeholder: opts[:placeholder],
         default_values: opts[:default_values] || [],
         min_values: min_values,
         max_values: Keyword.get(opts, :max_values, 1),
         required: Keyword.get(opts, :required, true),
         disabled: Keyword.get(opts, :disabled, false)
       }}
    end
  end

  def new(_, _), do: {:error, :invalid_role_select}

  defp validate_custom_id(value) when byte_size(value) in 1..100, do: :ok
  defp validate_custom_id(_), do: {:error, :invalid_custom_id}

  defp validate_placeholder(nil), do: :ok
  defp validate_placeholder(value) when byte_size(value) <= 150, do: :ok
  defp validate_placeholder(_), do: {:error, :invalid_placeholder}

  defp validate_default_values(nil), do: :ok
  defp validate_default_values(values) when is_list(values) and length(values) <= 25, do: :ok
  defp validate_default_values(_), do: {:error, :invalid_default_values}

  defp validate_min_values(min) when min >= 0 and min <= 25, do: :ok
  defp validate_min_values(_), do: {:error, :invalid_min_values}

  defp validate_max_values(max) when max >= 1 and max <= 25, do: :ok
  defp validate_max_values(_), do: {:error, :invalid_max_values}

  defp validate_required(true, 0), do: {:error, :min_values_required_when_required_is_true}
  defp validate_required(_, _), do: :ok
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.RoleSelect do
  def to_map(select) do
    %{
      type: 6,
      custom_id: select.custom_id,
      min_values: select.min_values,
      max_values: select.max_values,
      disabled: select.disabled
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, select.id)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:placeholder, select.placeholder)
    |> maybe_put_default_values(select.default_values)
  end

  defp maybe_put_default_values(map, []), do: map
  defp maybe_put_default_values(map, values) do
    Map.put(map, :default_values, Enum.map(values, &Discordex.Discord.Encodable.to_map/1))
  end
end
