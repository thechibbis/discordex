defmodule Discordex.Types.Components.Section do
  @moduledoc """
  Discord Section component.

  See: https://discord.com/developers/docs/interactions/message-components#section
  """

  alias Discordex.Types.Components.{Button, TextDisplay, Thumbnail}

  @enforce_keys [:components, :accessory]
  defstruct [:id, :components, :accessory]

  @type child :: TextDisplay.t()

  @type accessory :: Button.t() | Thumbnail.t()

  @type t :: %__MODULE__{
    id: integer() | nil,
    components: [child()],
    accessory: accessory()
  }

  @spec new([child()], accessory(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(components, accessory, opts \\ [])

  def new(components, accessory, opts) when is_list(components) and is_list(opts) do
    with :ok <- validate_components(components) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         components: components,
         accessory: accessory
       }}
    end
  end

  def new(_, _, _), do: {:error, :invalid_section}

  defp validate_components([]), do: {:error, :empty_components}
  defp validate_components(components) when length(components) > 3, do: {:error, :too_many_components}
  defp validate_components(components) when is_list(components), do: :ok
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Components.Section do
  def to_map(section) do
    %{
      type: 9,
      components: Enum.map(section.components, &Discordex.Types.Encodable.to_map/1),
      accessory: Discordex.Types.Encodable.to_map(section.accessory)
    }
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, section.id)
  end
end
