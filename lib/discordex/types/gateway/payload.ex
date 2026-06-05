defmodule Discordex.Types.Gateway.Payload do
  @moduledoc """
  Discord Gateway Payload envelope.

  Every message sent and received on the Discord gateway is wrapped
  in this common payload structure.

  See: https://discord.com/developers/docs/topics/gateway#payload-structure
  """

  defstruct [:op, :d, :s, :t]

  @type t :: %__MODULE__{
          op: integer(),
          d: term() | nil,
          s: integer() | nil,
          t: String.t() | nil
        }

  @doc """
  Decodes a raw map into a GatewayPayload struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      op: payload["op"],
      d: payload["d"],
      s: payload["s"],
      t: payload["t"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Gateway.Payload do
  alias Discordex.Types.Encodable

  def to_map(payload) do
    %{op: payload.op}
    |> Encodable.Helpers.maybe_put(:d, payload.d)
    |> Encodable.Helpers.maybe_put(:s, payload.s)
    |> Encodable.Helpers.maybe_put(:t, payload.t)
  end
end
