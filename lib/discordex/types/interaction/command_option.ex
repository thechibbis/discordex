defmodule Discordex.Types.Interaction.CommandOption do
  @moduledoc """
  Application command interaction data option.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-application-command-interaction-data-option-structure
  """

  alias __MODULE__

  @type value :: String.t() | integer() | float() | boolean()

  @type t :: %__MODULE__{
          name: String.t(),
          type: integer(),
          value: value() | nil,
          options: [CommandOption.t()] | nil,
          focused: boolean() | nil
        }

  defstruct [
    :name,
    :type,
    :value,
    :options,
    :focused
  ]

  @doc """
  Decodes a raw map into a CommandOption struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      name: payload["name"],
      type: payload["type"],
      value: payload["value"],
      options: decode_options(payload["options"]),
      focused: payload["focused"]
    }
  end

  defp decode_options(nil), do: nil
  defp decode_options(options) when is_list(options) do
    Enum.map(options, &decode/1)
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Interaction.CommandOption do
  def to_map(option) do
    %{name: option.name, type: option.type}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:value, option.value)
    |> maybe_put_options(option.options)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:focused, option.focused)
  end

  defp maybe_put_options(map, nil), do: map
  defp maybe_put_options(map, options) do
    Map.put(map, :options, Enum.map(options, &Discordex.Types.Encodable.to_map/1))
  end
end
