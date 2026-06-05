defmodule Discordex.Types.Interaction.Response do
  @moduledoc """
  Discord Interaction Response object.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object
  """

  defstruct [
    :type,
    :data
  ]

  @type t :: %__MODULE__{
          type: pos_integer(),
          data: map() | nil
        }

  @doc """
  Decodes a raw map into an InteractionResponse struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      type: payload["type"],
      data: payload["data"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Interaction.Response do
  alias Discordex.Types.Encodable

  def to_map(response) do
    %{}
    |> Map.put(:type, response.type)
    |> Encodable.Helpers.maybe_put(:data, response.data)
  end
end
