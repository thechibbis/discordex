defmodule Discordex.Types.WelcomeScreenChannel do
  @moduledoc """
  Discord Welcome Screen Channel object.

  See: https://docs.discord.com/developers/resources/guild#welcome-screen-channel-object
  """

  defstruct [
    :channel_id,
    :description,
    :emoji_id,
    :emoji_name
  ]

  @type t :: %__MODULE__{
          channel_id: String.t() | nil,
          description: String.t() | nil,
          emoji_id: String.t() | nil,
          emoji_name: String.t() | nil
        }

  @doc """
  Decodes a raw map into a WelcomeScreenChannel struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      channel_id: payload["channel_id"],
      description: payload["description"],
      emoji_id: payload["emoji_id"],
      emoji_name: payload["emoji_name"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.WelcomeScreenChannel do
  alias Discordex.Types.Encodable

  def to_map(struct) do
    %{}
    |> Encodable.Helpers.maybe_put(:channel_id, struct.channel_id)
    |> Encodable.Helpers.maybe_put(:description, struct.description)
    |> Encodable.Helpers.maybe_put(:emoji_id, struct.emoji_id)
    |> Encodable.Helpers.maybe_put(:emoji_name, struct.emoji_name)
  end
end
