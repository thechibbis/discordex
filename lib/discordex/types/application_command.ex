defmodule Discordex.Types.ApplicationCommand do
  @moduledoc """
  Application Command structure.

  See: https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-structure
  """

  alias Discordex.Types.ApplicationCommand.Option

  defstruct [
    :id,
    :type,
    :application_id,
    :guild_id,
    :name,
    :name_localizations,
    :description,
    :description_localizations,
    :options,
    :default_member_permissions,
    :dm_permission,
    :nsfw,
    :integration_types,
    :contexts,
    :handler
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          type: integer() | nil,
          application_id: String.t() | nil,
          guild_id: String.t() | nil,
          name: String.t(),
          name_localizations: map() | nil,
          description: String.t(),
          description_localizations: map() | nil,
          options: [ApplicationCommandOption.t()] | nil,
          default_member_permissions: String.t() | nil,
          dm_permission: boolean() | nil,
          nsfw: boolean() | nil,
          integration_types: [integer()] | nil,
          contexts: [integer()] | nil,
          handler: integer() | nil
        }

  @doc "Decodes a raw map into an ApplicationCommand struct."
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      type: payload["type"],
      application_id: payload["application_id"],
      guild_id: payload["guild_id"],
      name: payload["name"],
      name_localizations: payload["name_localizations"],
      description: payload["description"],
      description_localizations: payload["description_localizations"],
      options: decode_options(payload["options"]),
      default_member_permissions: payload["default_member_permissions"],
      dm_permission: payload["dm_permission"],
      nsfw: payload["nsfw"],
      integration_types: payload["integration_types"],
      contexts: payload["contexts"],
      handler: payload["handler"]
    }
  end

  defp decode_options(nil), do: nil
  defp decode_options(options) when is_list(options) do
    Enum.map(options, &Option.decode/1)
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.ApplicationCommand do
  alias Discordex.Types.Encodable
  alias Discordex.Types.Encodable.Helpers

  def to_map(cmd) do
    %{name: cmd.name, description: cmd.description}
    |> Helpers.maybe_put(:id, cmd.id)
    |> Helpers.maybe_put(:type, cmd.type)
    |> Helpers.maybe_put(:application_id, cmd.application_id)
    |> Helpers.maybe_put(:guild_id, cmd.guild_id)
    |> Helpers.maybe_put(:name_localizations, cmd.name_localizations)
    |> Helpers.maybe_put(:description_localizations, cmd.description_localizations)
    |> maybe_put_options(cmd.options)
    |> Helpers.maybe_put(:default_member_permissions, cmd.default_member_permissions)
    |> Helpers.maybe_put(:dm_permission, cmd.dm_permission)
    |> Helpers.maybe_put(:nsfw, cmd.nsfw)
    |> Helpers.maybe_put(:integration_types, cmd.integration_types)
    |> Helpers.maybe_put(:contexts, cmd.contexts)
    |> Helpers.maybe_put(:handler, cmd.handler)
  end

  defp maybe_put_options(map, nil), do: map
  defp maybe_put_options(map, options) do
    Map.put(map, :options, Enum.map(options, &Encodable.to_map/1))
  end
end
