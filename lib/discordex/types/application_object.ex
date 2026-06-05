defmodule Discordex.Types.ApplicationObject do
  @moduledoc """
  Discord Application object.

  See: https://docs.discord.com/developers/resources/application#application-object
  """

  alias Discordex.Types.User

  defstruct [
    :id,
    :name,
    :icon,
    :description,
    :rpc_origins,
    :bot_public,
    :bot_require_code_grant,
    :terms_of_service_url,
    :privacy_policy_url,
    :owner,
    :verify_key,
    :team,
    :guild_id,
    :primary_sku_id,
    :slug,
    :cover_image,
    :flags,
    :approximate_guild_count,
    :redirect_uris,
    :interactions_endpoint_url,
    :role_connections_verification_url,
    :tags,
    :install_params,
    :integration_types_config,
    :custom_install_url
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          icon: String.t() | nil,
          description: String.t() | nil,
          rpc_origins: [String.t()] | nil,
          bot_public: boolean() | nil,
          bot_require_code_grant: boolean() | nil,
          terms_of_service_url: String.t() | nil,
          privacy_policy_url: String.t() | nil,
          owner: User.t() | nil,
          verify_key: String.t() | nil,
          team: map() | nil,
          guild_id: String.t() | nil,
          primary_sku_id: String.t() | nil,
          slug: String.t() | nil,
          cover_image: String.t() | nil,
          flags: integer() | nil,
          approximate_guild_count: integer() | nil,
          redirect_uris: [String.t()] | nil,
          interactions_endpoint_url: String.t() | nil,
          role_connections_verification_url: String.t() | nil,
          tags: [String.t()] | nil,
          install_params: map() | nil,
          integration_types_config: map() | nil,
          custom_install_url: String.t() | nil
        }

  @doc """
  Decodes a raw map into an ApplicationObject struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      name: payload["name"],
      icon: payload["icon"],
      description: payload["description"],
      rpc_origins: payload["rpc_origins"],
      bot_public: payload["bot_public"],
      bot_require_code_grant: payload["bot_require_code_grant"],
      terms_of_service_url: payload["terms_of_service_url"],
      privacy_policy_url: payload["privacy_policy_url"],
      owner: decode_owner(payload["owner"]),
      verify_key: payload["verify_key"],
      team: payload["team"],
      guild_id: payload["guild_id"],
      primary_sku_id: payload["primary_sku_id"],
      slug: payload["slug"],
      cover_image: payload["cover_image"],
      flags: payload["flags"],
      approximate_guild_count: payload["approximate_guild_count"],
      redirect_uris: payload["redirect_uris"],
      interactions_endpoint_url: payload["interactions_endpoint_url"],
      role_connections_verification_url: payload["role_connections_verification_url"],
      tags: payload["tags"],
      install_params: payload["install_params"],
      integration_types_config: payload["integration_types_config"],
      custom_install_url: payload["custom_install_url"]
    }
  end

  defp decode_owner(nil), do: nil
  defp decode_owner(owner_map), do: User.decode(owner_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.ApplicationObject do
  alias Discordex.Types.Encodable.Helpers

  def to_map(app) do
    %{
      id: app.id,
      name: app.name,
      description: app.description,
      bot_public: app.bot_public,
      bot_require_code_grant: app.bot_require_code_grant,
      verify_key: app.verify_key
    }
    |> Helpers.maybe_put(:icon, app.icon)
    |> Helpers.maybe_put(:rpc_origins, app.rpc_origins)
    |> Helpers.maybe_put(:terms_of_service_url, app.terms_of_service_url)
    |> Helpers.maybe_put(:privacy_policy_url, app.privacy_policy_url)
    |> maybe_put_owner(app.owner)
    |> Helpers.maybe_put(:team, app.team)
    |> Helpers.maybe_put(:guild_id, app.guild_id)
    |> Helpers.maybe_put(:primary_sku_id, app.primary_sku_id)
    |> Helpers.maybe_put(:slug, app.slug)
    |> Helpers.maybe_put(:cover_image, app.cover_image)
    |> Helpers.maybe_put(:flags, app.flags)
    |> Helpers.maybe_put(:approximate_guild_count, app.approximate_guild_count)
    |> Helpers.maybe_put(:redirect_uris, app.redirect_uris)
    |> Helpers.maybe_put(:interactions_endpoint_url, app.interactions_endpoint_url)
    |> Helpers.maybe_put(:role_connections_verification_url, app.role_connections_verification_url)
    |> Helpers.maybe_put(:tags, app.tags)
    |> Helpers.maybe_put(:install_params, app.install_params)
    |> Helpers.maybe_put(:integration_types_config, app.integration_types_config)
    |> Helpers.maybe_put(:custom_install_url, app.custom_install_url)
  end

  defp maybe_put_owner(map, nil), do: map
  defp maybe_put_owner(map, owner) do
    Map.put(map, :owner, Discordex.Types.Encodable.to_map(owner))
  end
end
