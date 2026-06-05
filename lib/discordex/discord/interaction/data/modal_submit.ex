defmodule Discordex.Discord.Interaction.Data.ModalSubmit do
  @moduledoc """
  Modal submit interaction data.

  Sent in MODAL_SUBMIT (5) interactions.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-modal-submit-data-structure
  """

  alias Discordex.Discord.Interaction.ResolvedData

  defstruct [
    :custom_id,
    :components,
    :resolved
  ]

  @type t :: %__MODULE__{
          custom_id: String.t() | nil,
          components: [map()] | nil,
          resolved: ResolvedData.t() | nil
        }
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Interaction.Data.ModalSubmit do
  def to_map(data) do
    %{}
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:custom_id, data.custom_id)
    |> maybe_put_components(data.components)
    |> maybe_put_resolved(data.resolved)
  end

  defp maybe_put_components(map, nil), do: map
  defp maybe_put_components(map, components) do
    Map.put(map, :components, components)
  end

  defp maybe_put_resolved(map, nil), do: map
  defp maybe_put_resolved(map, resolved) do
    Map.put(map, :resolved, Discordex.Discord.Encodable.to_map(resolved))
  end
end
