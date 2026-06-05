defmodule Discordex.Types.Gateway.Resume do
  @moduledoc """
  Discord Gateway Resume payload.

  Sent by the client to resume a previously disconnected session.

  See: https://discord.com/developers/docs/topics/gateway#resume
  """

  defstruct [:token, :session_id, :seq]

  @type t :: %__MODULE__{
          token: String.t(),
          session_id: String.t(),
          seq: integer()
        }

  @doc """
  Decodes a raw map into a GatewayResume struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      token: payload["token"],
      session_id: payload["session_id"],
      seq: payload["seq"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Gateway.Resume do
  def to_map(resume) do
    %{
      token: resume.token,
      session_id: resume.session_id,
      seq: resume.seq
    }
  end
end
