defmodule Discordex.Types.Components.Container do
  @moduledoc """
  Discord Container component.

  See: https://discord.com/developers/docs/interactions/message-components#container
  """

  alias Discordex.Types.Components.{
    ActionRow,
    File,
    MediaGallery,
    Section,
    Separator,
    TextDisplay
  }

  @enforce_keys [:components]
  defstruct [
    :id,
    :components,
    :accent_color,
    spoiler: false
  ]

  @type child ::
          ActionRow.t()
          | TextDisplay.t()
          | Section.t()
          | MediaGallery.t()
          | Separator.t()
          | File.t()

  @type t :: %__MODULE__{
    id: integer() | nil,
    components: [child()],
    accent_color: integer() | nil,
    spoiler: boolean()
  }

  @spec new([child()], keyword()) :: {:ok, t()} | {:error, term()}
  def new(components, opts \\ [])

  def new(components, opts) when is_list(components) and is_list(opts) do
    with :ok <- validate_accent_color(opts[:accent_color]) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         components: components,
         accent_color: opts[:accent_color],
         spoiler: Keyword.get(opts, :spoiler, false)
       }}
    end
  end

  def new(_, _), do: {:error, :invalid_container}

  defp validate_accent_color(nil), do: :ok
  defp validate_accent_color(value) when is_integer(value) and value >= 0 and value <= 0xFFFFFF, do: :ok
  defp validate_accent_color(_), do: {:error, :invalid_accent_color}
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Components.Container do
  def to_map(container) do
    %{
      type: 17,
      components: Enum.map(container.components, &Discordex.Types.Encodable.to_map/1),
      spoiler: container.spoiler
    }
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, container.id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:accent_color, container.accent_color)
  end
end
