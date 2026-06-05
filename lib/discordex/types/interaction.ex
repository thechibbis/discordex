defmodule Discordex.Types.Interaction do
  @moduledoc """
  Discord Interaction object received when a user uses an application command or message component.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object
  """

  alias __MODULE__.{Type, ContextType, Data}
  alias Discordex.Types.{User, GuildMember, Channel, Guild, Message, Entitlement}

  @type t :: %__MODULE__{
          id: String.t(),
          application_id: String.t(),
          type: Type.t(),
          data: Data.t() | nil,
          guild: Guild.t() | nil,
          guild_id: String.t() | nil,
          channel: Channel.t() | nil,
          channel_id: String.t() | nil,
          member: GuildMember.t() | nil,
          user: User.t() | nil,
          token: String.t(),
          version: integer(),
          message: Message.t() | nil,
          app_permissions: String.t(),
          locale: String.t() | nil,
          guild_locale: String.t() | nil,
          entitlements: [Entitlement.t()],
          authorizing_integration_owners: map(),
          context: ContextType.t() | nil,
          attachment_size_limit: integer()
        }

  defstruct [
    :id,
    :application_id,
    :type,
    :data,
    :guild,
    :guild_id,
    :channel,
    :channel_id,
    :member,
    :user,
    :token,
    :version,
    :message,
    :app_permissions,
    :locale,
    :guild_locale,
    :entitlements,
    :authorizing_integration_owners,
    :context,
    :attachment_size_limit
  ]

  @doc """
  Decodes a raw map (from Discord gateway or webhook) into an Interaction struct.

  Returns `{:ok, Interaction.t()}` on success, or `{:error, reason}` on failure.
  """
  @spec decode(map()) :: {:ok, t()} | {:error, term()}
  def decode(payload) when is_map(payload) do
    with {:ok, type} <- Type.decode(payload["type"]) do
      {:ok,
       %__MODULE__{
         id: payload["id"],
         application_id: payload["application_id"],
         type: type,
         data: decode_data(type, payload["data"]),
         guild: decode_guild(payload["guild"]),
         guild_id: payload["guild_id"],
         channel: decode_channel(payload["channel"]),
         channel_id: payload["channel_id"],
         member: decode_member(payload["member"]),
         user: decode_user(payload["user"]),
         token: payload["token"],
         version: payload["version"],
         message: decode_message(payload["message"]),
         app_permissions: payload["app_permissions"],
         locale: payload["locale"],
         guild_locale: payload["guild_locale"],
         entitlements: decode_entitlements(payload["entitlements"]),
         authorizing_integration_owners: payload["authorizing_integration_owners"] || %{},
         context: decode_context(payload["context"]),
         attachment_size_limit: payload["attachment_size_limit"]
       }}
    end
  end

  def decode(_), do: {:error, :invalid_interaction_payload}

  defp decode_data(_type, nil), do: nil

  defp decode_data(:application_command, data) do
    struct(Data.ApplicationCommand, %{
      id: data["id"],
      name: data["name"],
      type: data["type"],
      resolved: decode_resolved_data(data["resolved"]),
      options: decode_command_options(data["options"]),
      guild_id: data["guild_id"],
      target_id: data["target_id"]
    })
  end

  defp decode_data(:application_command_autocomplete, data) do
    struct(Data.ApplicationCommand, %{
      id: data["id"],
      name: data["name"],
      type: data["type"],
      resolved: decode_resolved_data(data["resolved"]),
      options: decode_command_options(data["options"]),
      guild_id: data["guild_id"],
      target_id: data["target_id"]
    })
  end

  defp decode_data(:message_component, data) do
    struct(Data.MessageComponent, %{
      custom_id: data["custom_id"],
      component_type: data["component_type"],
      values: data["values"],
      resolved: decode_resolved_data(data["resolved"])
    })
  end

  defp decode_data(:modal_submit, data) do
    struct(Data.ModalSubmit, %{
      custom_id: data["custom_id"],
      components: data["components"],
      resolved: decode_resolved_data(data["resolved"])
    })
  end

  defp decode_data(_, _), do: nil

  defp decode_user(nil), do: nil
  defp decode_user(user_map), do: User.decode(user_map)

  defp decode_member(nil), do: nil
  defp decode_member(member_map), do: GuildMember.decode(member_map)

  defp decode_guild(nil), do: nil
  defp decode_guild(guild_map), do: Guild.decode(guild_map)

  defp decode_channel(nil), do: nil
  defp decode_channel(channel_map), do: Channel.decode(channel_map)

  defp decode_message(nil), do: nil
  defp decode_message(message_map), do: Message.decode(message_map)

  defp decode_entitlements(nil), do: []
  defp decode_entitlements(entitlements) when is_list(entitlements) do
    Enum.map(entitlements, &Entitlement.decode/1)
  end

  defp decode_resolved_data(nil), do: nil

  defp decode_resolved_data(resolved) do
    struct(__MODULE__.ResolvedData, %{
      users: decode_resolved_map(resolved["users"], &User.decode/1),
      members: decode_resolved_map(resolved["members"], &GuildMember.decode/1),
      roles: decode_resolved_map(resolved["roles"], &Discordex.Types.Role.decode/1),
      channels: decode_resolved_map(resolved["channels"], &Channel.decode/1),
      messages: decode_resolved_map(resolved["messages"], &Message.decode/1),
      attachments: decode_resolved_map(resolved["attachments"], &Discordex.Types.Attachment.decode/1)
    })
  end

  defp decode_resolved_map(nil, _decoder), do: nil
  defp decode_resolved_map(map, decoder) when is_map(map) do
    Map.new(map, fn {k, v} -> {k, decoder.(v)} end)
  end

  defp decode_command_options(nil), do: nil
  defp decode_command_options(options) when is_list(options) do
    Enum.map(options, fn opt ->
      struct(__MODULE__.CommandOption, %{
        name: opt["name"],
        type: opt["type"],
        value: opt["value"],
        options: decode_command_options(opt["options"]),
        focused: opt["focused"]
      })
    end)
  end

  defp decode_context(nil), do: nil
  defp decode_context(context) do
    case ContextType.decode(context) do
      {:ok, ctx} -> ctx
      :error -> nil
    end
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Interaction do
  alias Discordex.Types.Interaction.Type
  alias Discordex.Types.Encodable.Helpers
  alias Discordex.Types.Encodable

  def to_map(interaction) do
    %{
      id: interaction.id,
      application_id: interaction.application_id,
      type: Type.encode(interaction.type),
      token: interaction.token,
      version: interaction.version,
      app_permissions: interaction.app_permissions,
      entitlements: Enum.map(interaction.entitlements, &Encodable.to_map/1),
      authorizing_integration_owners: interaction.authorizing_integration_owners,
      attachment_size_limit: interaction.attachment_size_limit
    }
    |> maybe_put_data(interaction.data)
    |> maybe_put_nested(:guild, interaction.guild)
    |> Helpers.maybe_put(:guild_id, interaction.guild_id)
    |> maybe_put_nested(:channel, interaction.channel)
    |> Helpers.maybe_put(:channel_id, interaction.channel_id)
    |> maybe_put_nested(:member, interaction.member)
    |> maybe_put_nested(:user, interaction.user)
    |> maybe_put_nested(:message, interaction.message)
    |> Helpers.maybe_put(:locale, interaction.locale)
    |> Helpers.maybe_put(:guild_locale, interaction.guild_locale)
    |> maybe_put_context(interaction.context)
  end

  defp maybe_put_data(map, nil), do: map
  defp maybe_put_data(map, data) do
    Map.put(map, :data, Encodable.to_map(data))
  end

  defp maybe_put_nested(map, _key, nil), do: map
  defp maybe_put_nested(map, key, value) do
    Map.put(map, key, Encodable.to_map(value))
  end

  defp maybe_put_context(map, nil), do: map
  defp maybe_put_context(map, context) do
    Map.put(map, :context, Discordex.Types.Interaction.ContextType.encode(context))
  end
end
