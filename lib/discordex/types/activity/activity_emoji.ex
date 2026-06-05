defmodule Discordex.Types.Activity.ActivityEmoji do
  @moduledoc """
  Activity Emoji object.

  See: https://docs.discord.com/developers/resources/activity#activity-object-activity-emoji
  """

  defstruct [
    :name,
    :id,
    :animated
  ]

  @type t :: %__MODULE__{
          name: String.t() | nil,
          id: String.t() | nil,
          animated: boolean() | nil
        }

  @doc """
  Decodes a raw map into an Activity.ActivityEmoji struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      name: payload["name"],
      id: payload["id"],
      animated: payload["animated"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Activity.ActivityEmoji do
  alias Discordex.Types.Encodable

  def to_map(activity_emoji) do
    %{}
    |> Encodable.Helpers.maybe_put(:name, activity_emoji.name)
    |> Encodable.Helpers.maybe_put(:id, activity_emoji.id)
    |> Encodable.Helpers.maybe_put(:animated, activity_emoji.animated)
  end
end
