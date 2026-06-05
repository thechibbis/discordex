defmodule Discordex.Types.Components.File do
  @moduledoc """
  Discord File component.

  See: https://discord.com/developers/docs/interactions/message-components#file
  """

  alias Discordex.Types.UnfurledMediaItem

  @enforce_keys [:file]
  defstruct [
    :id,
    :file,
    spoiler: false
  ]

  @type t :: %__MODULE__{
    id: integer() | nil,
    file: UnfurledMediaItem.t(),
    spoiler: boolean()
  }

  @spec new(UnfurledMediaItem.t(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(file, opts \\ [])

  def new(file, opts) when is_list(opts) do
    {:ok,
     %__MODULE__{
       id: opts[:id],
       file: file,
       spoiler: Keyword.get(opts, :spoiler, false)
     }}
  end

  def new(_, _), do: {:error, :invalid_file}
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Components.File do
  def to_map(file) do
    %{
      type: 13,
      file: Discordex.Types.Encodable.to_map(file.file),
      spoiler: file.spoiler
    }
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, file.id)
  end
end
