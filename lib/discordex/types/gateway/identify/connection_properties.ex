defmodule Discordex.Types.Gateway.Identify.ConnectionProperties do
  @moduledoc """
  Connection properties sent as part of the Gateway Identify payload.

  See: https://discord.com/developers/docs/topics/gateway#identify-identify-connection-properties
  """

  defstruct [:os, :browser, :device]

  @type t :: %__MODULE__{
          os: String.t(),
          browser: String.t(),
          device: String.t()
        }

  @doc """
  Decodes a raw map into a ConnectionProperties struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      os: payload["os"],
      browser: payload["browser"],
      device: payload["device"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Gateway.Identify.ConnectionProperties do
  def to_map(properties) do
    %{
      os: properties.os,
      browser: properties.browser,
      device: properties.device
    }
  end
end
