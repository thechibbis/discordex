defmodule Discordex.Types.Activity.Assets do
  @moduledoc """
  Activity Assets object.

  See: https://docs.discord.com/developers/resources/activity#activity-object-activity-assets
  """

  defstruct [
    :large_image,
    :large_text,
    :small_image,
    :small_text
  ]

  @type t :: %__MODULE__{
          large_image: String.t() | nil,
          large_text: String.t() | nil,
          small_image: String.t() | nil,
          small_text: String.t() | nil
        }

  @doc """
  Decodes a raw map into an Activity.Assets struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      large_image: payload["large_image"],
      large_text: payload["large_text"],
      small_image: payload["small_image"],
      small_text: payload["small_text"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Activity.Assets do
  alias Discordex.Types.Encodable

  def to_map(assets) do
    %{}
    |> Encodable.Helpers.maybe_put(:large_image, assets.large_image)
    |> Encodable.Helpers.maybe_put(:large_text, assets.large_text)
    |> Encodable.Helpers.maybe_put(:small_image, assets.small_image)
    |> Encodable.Helpers.maybe_put(:small_text, assets.small_text)
  end
end
