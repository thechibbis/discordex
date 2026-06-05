defmodule Discordex.Types.ApplicationCommand.Option do
  @moduledoc """
  Application Command Option structure.

  See: https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-structure
  """

  alias Discordex.Types.ApplicationCommand.OptionChoice

  defstruct [
    :type,
    :name,
    :name_localizations,
    :description,
    :description_localizations,
    :required,
    :choices,
    :options,
    :channel_types,
    :min_value,
    :max_value,
    :min_length,
    :max_length,
    :autocomplete
  ]

  @typedoc "Min/max value for numeric options"
  @type num_range :: integer() | float()

  @type t :: %__MODULE__{
          type: integer(),
          name: String.t(),
          name_localizations: map() | nil,
          description: String.t(),
          description_localizations: map() | nil,
          required: boolean() | nil,
          choices: [OptionChoice.t()] | nil,
          options: [__MODULE__.t()] | nil,
          channel_types: [integer()] | nil,
          min_value: num_range() | nil,
          max_value: num_range() | nil,
          min_length: integer() | nil,
          max_length: integer() | nil,
          autocomplete: boolean() | nil
        }

  @doc "Decodes a raw map into an ApplicationCommandOption struct."
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      type: payload["type"],
      name: payload["name"],
      name_localizations: payload["name_localizations"],
      description: payload["description"],
      description_localizations: payload["description_localizations"],
      required: payload["required"],
      choices: decode_choices(payload["choices"]),
      options: decode_options(payload["options"]),
      channel_types: payload["channel_types"],
      min_value: payload["min_value"],
      max_value: payload["max_value"],
      min_length: payload["min_length"],
      max_length: payload["max_length"],
      autocomplete: payload["autocomplete"]
    }
  end

  defp decode_choices(nil), do: nil
  defp decode_choices(choices) when is_list(choices) do
    Enum.map(choices, &OptionChoice.decode/1)
  end

  defp decode_options(nil), do: nil
  defp decode_options(options) when is_list(options) do
    Enum.map(options, &decode/1)
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.ApplicationCommand.Option do
  alias Discordex.Types.Encodable
  alias Discordex.Types.Encodable.Helpers

  def to_map(option) do
    %{type: option.type, name: option.name, description: option.description}
    |> Helpers.maybe_put(:name_localizations, option.name_localizations)
    |> Helpers.maybe_put(:description_localizations, option.description_localizations)
    |> Helpers.maybe_put(:required, option.required)
    |> maybe_put_choices(option.choices)
    |> maybe_put_options(option.options)
    |> Helpers.maybe_put(:channel_types, option.channel_types)
    |> Helpers.maybe_put(:min_value, option.min_value)
    |> Helpers.maybe_put(:max_value, option.max_value)
    |> Helpers.maybe_put(:min_length, option.min_length)
    |> Helpers.maybe_put(:max_length, option.max_length)
    |> Helpers.maybe_put(:autocomplete, option.autocomplete)
  end

  defp maybe_put_choices(map, nil), do: map
  defp maybe_put_choices(map, choices) do
    Map.put(map, :choices, Enum.map(choices, &Encodable.to_map/1))
  end

  defp maybe_put_options(map, nil), do: map
  defp maybe_put_options(map, options) do
    Map.put(map, :options, Enum.map(options, &Encodable.to_map/1))
  end
end
