defmodule Discordex.Discord.Components.Button.Premium do
  @enforce_keys [:sku_id]
  defstruct [
    :id,
    :sku_id,
    disabled: false
  ]

  @type t :: %__MODULE__{
            id: integer() | nil,
            sku_id: String.t(),
            disabled: boolean()
          }

  @spec new(String.t(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(sku_id, opts \\ [])

  def new(sku_id, opts) when is_binary(sku_id) and sku_id != "" and is_list(opts) do
    with :ok <- validate_sku_id(sku_id) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         sku_id: sku_id,
         disabled: Keyword.get(opts, :disabled, false)
       }}
    end
  end

  def new(_, _), do: {:error, :invalid_sku_id}

  # TODO! Implement the snowflake validator
  defp validate_sku_id(_sku_id), do: :ok
end

defimpl Discordex.Discord.Encodable,
  for: Discordex.Discord.Components.Button.Premium do
  def to_map(button) do
    %{
      type: 2,
      style: 6,
      sku_id: button.sku_id,
      disabled: button.disabled
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, button.id)
  end

end
