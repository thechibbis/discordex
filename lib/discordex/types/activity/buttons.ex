defmodule Discordex.Types.Activity.Buttons do
  @moduledoc """
  Activity Buttons object.

  See: https://docs.discord.com/developers/resources/activity#activity-object-activity-buttons
  """

  defstruct [
    :label,
    :url
  ]

  @type t :: %__MODULE__{
          label: String.t() | nil,
          url: String.t() | nil
        }

  @doc """
  Decodes a raw map into an Activity.Buttons struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      label: payload["label"],
      url: payload["url"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Activity.Buttons do
  alias Discordex.Types.Encodable

  def to_map(buttons) do
    %{}
    |> Encodable.Helpers.maybe_put(:label, buttons.label)
    |> Encodable.Helpers.maybe_put(:url, buttons.url)
  end
end
