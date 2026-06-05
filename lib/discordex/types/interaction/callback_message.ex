defmodule Discordex.Types.Interaction.CallbackMessage do
  @moduledoc """
  Discord Interaction Callback Message object.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-message
  """

  defstruct [
    :tts,
    :content,
    :embeds,
    :allowed_mentions,
    :flags,
    :components,
    :attachments,
    :poll
  ]

  @type t :: %__MODULE__{
          tts: boolean() | nil,
          content: String.t() | nil,
          embeds: [map()] | nil,
          allowed_mentions: map() | nil,
          flags: integer() | nil,
          components: [map()] | nil,
          attachments: [map()] | nil,
          poll: map() | nil
        }

  @doc """
  Decodes a raw map into an InteractionCallbackMessage struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      tts: payload["tts"],
      content: payload["content"],
      embeds: payload["embeds"],
      allowed_mentions: payload["allowed_mentions"],
      flags: payload["flags"],
      components: payload["components"],
      attachments: payload["attachments"],
      poll: payload["poll"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Interaction.CallbackMessage do
  alias Discordex.Types.Encodable

  def to_map(message) do
    %{}
    |> Encodable.Helpers.maybe_put(:tts, message.tts)
    |> Encodable.Helpers.maybe_put(:content, message.content)
    |> Encodable.Helpers.maybe_put(:embeds, message.embeds)
    |> Encodable.Helpers.maybe_put(:allowed_mentions, message.allowed_mentions)
    |> Encodable.Helpers.maybe_put(:flags, message.flags)
    |> Encodable.Helpers.maybe_put(:components, message.components)
    |> Encodable.Helpers.maybe_put(:attachments, message.attachments)
    |> Encodable.Helpers.maybe_put(:poll, message.poll)
  end
end
