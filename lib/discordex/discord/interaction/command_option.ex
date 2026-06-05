defmodule Discordex.Discord.Interaction.CommandOption do
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
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Interaction.CommandOption do
  def to_map(option) do
    %{name: option.name, type: option.type}
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:value, option.value)
    |> maybe_put_options(option.options)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:focused, option.focused)
  end

  defp maybe_put_options(map, nil), do: map
  defp maybe_put_options(map, options) do
    Map.put(map, :options, Enum.map(options, &Discordex.Discord.Encodable.to_map/1))
  end
end
