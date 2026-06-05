defmodule Discordex.Types.Gateway.Identify do
  @moduledoc """
  Discord Gateway Identify payload.

  Sent by the client after opening a websocket connection to identify
  itself to the gateway.

  See: https://discord.com/developers/docs/topics/gateway#identify
  """

  alias Discordex.Types.Gateway.Identify.ConnectionProperties

  defstruct [:token, :properties, :compress, :large_threshold, :shard, :presence, :intents]

  @type t :: %__MODULE__{
          token: String.t(),
          properties: ConnectionProperties.t(),
          compress: boolean() | nil,
          large_threshold: integer() | nil,
          shard: [integer()] | nil,
          presence: map() | nil,
          intents: integer()
        }

  @doc """
  Decodes a raw map into a GatewayIdentify struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      token: payload["token"],
      properties: ConnectionProperties.decode(payload["properties"]),
      compress: payload["compress"],
      large_threshold: payload["large_threshold"],
      shard: payload["shard"],
      presence: payload["presence"],
      intents: payload["intents"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Gateway.Identify do
  alias Discordex.Types.Encodable
  alias Discordex.Types.Encodable.Helpers

  def to_map(identify) do
    %{
      token: identify.token,
      properties: Encodable.to_map(identify.properties),
      intents: identify.intents
    }
    |> Helpers.maybe_put(:compress, identify.compress)
    |> Helpers.maybe_put(:large_threshold, identify.large_threshold)
    |> Helpers.maybe_put(:shard, identify.shard)
    |> Helpers.maybe_put(:presence, identify.presence)
  end
end
