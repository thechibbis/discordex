defmodule Discordex.Types.Components.Separator do
  @moduledoc """
  Discord Separator component.

  See: https://discord.com/developers/docs/interactions/message-components#separator
  """

  defstruct [
    :id,
    divider: true,
    spacing: 1
  ]

  @type t :: %__MODULE__{
    id: integer() | nil,
    divider: boolean(),
    spacing: integer()
  }

  @spec new(keyword()) :: {:ok, t()} | {:error, term()}
  def new(opts \\ [])

  def new(opts) when is_list(opts) do
    with :ok <- validate_spacing(Keyword.get(opts, :spacing, 1)) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         divider: Keyword.get(opts, :divider, true),
         spacing: Keyword.get(opts, :spacing, 1)
       }}
    end
  end

  def new(_), do: {:error, :invalid_separator}

  defp validate_spacing(value) when value in [1, 2], do: :ok
  defp validate_spacing(_), do: {:error, :invalid_spacing}
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Components.Separator do
  def to_map(separator) do
    %{
      type: 14,
      divider: separator.divider,
      spacing: separator.spacing
    }
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, separator.id)
  end
end
