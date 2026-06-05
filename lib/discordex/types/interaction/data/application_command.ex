defmodule Discordex.Types.Interaction.Data.ApplicationCommand do
  @moduledoc """
  Application command interaction data.

  Sent in APPLICATION_COMMAND (2) and APPLICATION_COMMAND_AUTOCOMPLETE (4) interactions.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-application-command-data-structure
  """

  alias Discordex.Types.Interaction.{CommandOption, ResolvedData}

  defstruct [
    :id,
    :name,
    :type,
    :resolved,
    :options,
    :guild_id,
    :target_id
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          type: integer() | nil,
          resolved: ResolvedData.t() | nil,
          options: [CommandOption.t()] | nil,
          guild_id: String.t() | nil,
          target_id: String.t() | nil
        }
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Interaction.Data.ApplicationCommand do
  def to_map(data) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, data.id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:name, data.name)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:type, data.type)
    |> maybe_put_resolved(data.resolved)
    |> maybe_put_options(data.options)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:guild_id, data.guild_id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:target_id, data.target_id)
  end

  defp maybe_put_resolved(map, nil), do: map
  defp maybe_put_resolved(map, resolved) do
    Map.put(map, :resolved, Discordex.Types.Encodable.to_map(resolved))
  end

  defp maybe_put_options(map, nil), do: map
  defp maybe_put_options(map, options) do
    Map.put(map, :options, Enum.map(options, &Discordex.Types.Encodable.to_map/1))
  end
end
