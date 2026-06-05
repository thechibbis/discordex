defmodule Discordex.Types.ApplicationCommand.OptionChoice do
  @moduledoc """
  Application Command Option Choice structure.

  See: https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-choice-structure
  """

  defstruct [
    :name,
    :name_localizations,
    :value
  ]

  @typedoc "The value type for the choice, which can be a string, integer, or float"
  @type choice_value :: String.t() | integer() | float()

  @type t :: %__MODULE__{
          name: String.t(),
          name_localizations: map() | nil,
          value: choice_value()
        }

  @doc "Decodes a raw map into an ApplicationCommandOptionChoice struct."
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      name: payload["name"],
      name_localizations: payload["name_localizations"],
      value: payload["value"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.ApplicationCommand.OptionChoice do
  alias Discordex.Types.Encodable.Helpers

  def to_map(choice) do
    %{name: choice.name, value: choice.value}
    |> Helpers.maybe_put(:name_localizations, choice.name_localizations)
  end
end
