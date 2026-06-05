defmodule Discordex.Types.Interaction.CallbackAutocomplete do
  @moduledoc """
  Discord Interaction Callback Autocomplete object.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-autocomplete
  """

  defstruct [
    :choices
  ]

  @type t :: %__MODULE__{
          choices: [map()]
        }

  @doc """
  Decodes a raw map into an InteractionCallbackAutocomplete struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      choices: payload["choices"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Interaction.CallbackAutocomplete do

  def to_map(autocomplete) do
    %{}
    |> Map.put(:choices, autocomplete.choices)
  end
end
