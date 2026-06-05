defmodule Discordex.Discord.Interaction.Data.MessageComponent do
  @moduledoc """
  Message component interaction data.

  Sent in MESSAGE_COMPONENT (3) interactions.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-message-component-data-structure
  """

  alias Discordex.Discord.Interaction.ResolvedData

  defstruct [
    :custom_id,
    :component_type,
    :values,
    :resolved
  ]

  @type t :: %__MODULE__{
          custom_id: String.t() | nil,
          component_type: integer() | nil,
          values: [String.t()] | nil,
          resolved: ResolvedData.t() | nil
        }
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Interaction.Data.MessageComponent do
  def to_map(data) do
    %{}
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:custom_id, data.custom_id)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:component_type, data.component_type)
    |> maybe_put_values(data.values)
    |> maybe_put_resolved(data.resolved)
  end

  defp maybe_put_values(map, nil), do: map
  defp maybe_put_values(map, values) do
    Map.put(map, :values, values)
  end

  defp maybe_put_resolved(map, nil), do: map
  defp maybe_put_resolved(map, resolved) do
    Map.put(map, :resolved, Discordex.Discord.Encodable.to_map(resolved))
  end
end
