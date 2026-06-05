defmodule Discordex.Types.Interaction.ResolvedData do
  @moduledoc """
  Resolved data structure mapping snowflake IDs to full Discord objects.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-resolved-data-structure
  """

  alias Discordex.Types.{User, GuildMember, Role, Channel, Message, Attachment}

  @type user_map :: %{String.t() => User.t()}
  @type member_map :: %{String.t() => GuildMember.t()}
  @type role_map :: %{String.t() => Role.t()}
  @type channel_map :: %{String.t() => Channel.t()}
  @type message_map :: %{String.t() => Message.t()}
  @type attachment_map :: %{String.t() => Attachment.t()}

  @type t :: %__MODULE__{
          users: user_map() | nil,
          members: member_map() | nil,
          roles: role_map() | nil,
          channels: channel_map() | nil,
          messages: message_map() | nil,
          attachments: attachment_map() | nil
        }

  defstruct [
    :users,
    :members,
    :roles,
    :channels,
    :messages,
    :attachments
  ]
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Interaction.ResolvedData do
  alias Discordex.Types.Encodable

  def to_map(resolved) do
    %{}
    |> maybe_put_resolved_map(:users, resolved.users)
    |> maybe_put_resolved_map(:members, resolved.members)
    |> maybe_put_resolved_map(:roles, resolved.roles)
    |> maybe_put_resolved_map(:channels, resolved.channels)
    |> maybe_put_resolved_map(:messages, resolved.messages)
    |> maybe_put_resolved_map(:attachments, resolved.attachments)
  end

  defp maybe_put_resolved_map(map, _key, nil), do: map
  defp maybe_put_resolved_map(map, key, value) do
    Map.put(map, key, Map.new(value, fn {k, v} -> {k, Encodable.to_map(v)} end))
  end
end
