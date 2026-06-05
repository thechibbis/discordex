defmodule Discordex.Types.MessageReference do
  @moduledoc """
  Discord Message Reference object.

  See: https://docs.discord.com/developers/resources/message#message-reference-structure
  """

  defstruct [
    :message_id,
    :channel_id,
    :guild_id,
    :fail_if_not_exists
  ]

  @type t :: %__MODULE__{
          message_id: String.t() | nil,
          channel_id: String.t() | nil,
          guild_id: String.t() | nil,
          fail_if_not_exists: boolean() | nil
        }

  @doc """
  Decodes a raw map into a MessageReference struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      message_id: payload["message_id"],
      channel_id: payload["channel_id"],
      guild_id: payload["guild_id"],
      fail_if_not_exists: payload["fail_if_not_exists"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.MessageReference do
  alias Discordex.Types.Encodable

  def to_map(message_reference) do
    %{}
    |> Encodable.Helpers.maybe_put(:message_id, message_reference.message_id)
    |> Encodable.Helpers.maybe_put(:channel_id, message_reference.channel_id)
    |> Encodable.Helpers.maybe_put(:guild_id, message_reference.guild_id)
    |> Encodable.Helpers.maybe_put(:fail_if_not_exists, message_reference.fail_if_not_exists)
  end
end
