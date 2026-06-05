defmodule Discordex.Types.Components.Button.Link do
  @enforce_keys [:url]
  defstruct [
    :id,
    :url,
    :label,
    :emoji,
    disabled: false
  ]

  @type t :: %__MODULE__{
            id: integer() | nil,
            url: String.t(),
            label: String.t() | nil,
            emoji: map() | nil,
            disabled: boolean()
          }

  @spec new(String.t(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(url, opts \\ [])

  def new(url, opts) when is_binary(url) and is_list(opts) do
    with :ok <- validate_url(url),
         :ok <- validate_label(opts[:label]) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         url: url,
         label: opts[:label],
         emoji: opts[:emoji],
         disabled: Keyword.get(opts, :disabled, false)
       }}
    end
  end

  def new(_, _), do: {:error, :invalid_url}

  defp validate_url(value) when byte_size(value) in 1..512, do: :ok
  defp validate_url(_), do: {:error, :invalid_url}

  defp validate_label(nil), do: :ok
  defp validate_label(value) when is_binary(value) and byte_size(value) <= 80, do: :ok
  defp validate_label(_), do: {:error, :invalid_label}
end

defimpl Discordex.Types.Encodable,
  for: Discordex.Types.Components.Button.Link do
  def to_map(button) do
    %{
      type: 2,
      style: 5,
      url: button.url,
      disabled: button.disabled
    }
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, button.id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:label, button.label)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:emoji, button.emoji)
  end

end
