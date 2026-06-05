defmodule Discordex.Types.Interaction.CallbackModal do
  @moduledoc """
  Discord Interaction Callback Modal object.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-modal
  """

  defstruct [
    :custom_id,
    :title,
    :components
  ]

  @type t :: %__MODULE__{
          custom_id: String.t(),
          title: String.t(),
          components: [map()]
        }

  @doc """
  Decodes a raw map into an InteractionCallbackModal struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      custom_id: payload["custom_id"],
      title: payload["title"],
      components: payload["components"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Interaction.CallbackModal do

  def to_map(modal) do
    %{}
    |> Map.put(:custom_id, modal.custom_id)
    |> Map.put(:title, modal.title)
    |> Map.put(:components, modal.components)
  end
end
