defmodule Discordex.Types.WelcomeScreen do
  @moduledoc """
  Discord Welcome Screen object.

  See: https://docs.discord.com/developers/resources/guild#welcome-screen-object
  """

  alias Discordex.Types.WelcomeScreenChannel

  defstruct [
    :description,
    :welcome_channels
  ]

  @type t :: %__MODULE__{
          description: String.t() | nil,
          welcome_channels: [WelcomeScreenChannel.t()] | nil
        }

  @doc """
  Decodes a raw map into a WelcomeScreen struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      description: payload["description"],
      welcome_channels: decode_welcome_channels(payload["welcome_channels"])
    }
  end

  defp decode_welcome_channels(nil), do: nil
  defp decode_welcome_channels(channels) when is_list(channels), do: Enum.map(channels, &WelcomeScreenChannel.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.WelcomeScreen do
  alias Discordex.Types.Encodable

  def to_map(struct) do
    %{}
    |> Encodable.Helpers.maybe_put(:description, struct.description)
    |> maybe_put_welcome_channels(struct.welcome_channels)
  end

  defp maybe_put_welcome_channels(map, nil), do: map
  defp maybe_put_welcome_channels(map, channels) do
    Map.put(map, :welcome_channels, Enum.map(channels, &Encodable.to_map/1))
  end
end
