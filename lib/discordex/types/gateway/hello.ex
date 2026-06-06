defmodule Discordex.Types.Gateway.Hello do
  @moduledoc """
  Discord Gateway Hello payload.

  Sent by the gateway upon initial connection to indicate the
  heartbeat interval the client should use.

  See: https://discord.com/developers/docs/topics/gateway#hello
  """

  defstruct [:heartbeat_interval]

  @type t :: %__MODULE__{
          heartbeat_interval: integer()
        }

  @doc """
  Decodes a raw map into a GatewayHello struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      heartbeat_interval: payload["d"]["heartbeat_interval"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Gateway.Hello do
  def to_map(hello) do
    %{heartbeat_interval: hello.heartbeat_interval}
  end
end
