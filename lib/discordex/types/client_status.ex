defmodule Discordex.Types.ClientStatus do
  @moduledoc """
  Discord Client Status object.

  Active sessions are indicated with an "online", "idle", or "dnd" string per platform.

  See: https://docs.discord.com/developers/topics/gateway-events#client-status-object
  """

  defstruct [
    :desktop,
    :mobile,
    :web
  ]

  @type t :: %__MODULE__{
          desktop: String.t() | nil,
          mobile: String.t() | nil,
          web: String.t() | nil
        }

  @doc """
  Decodes a raw map into a ClientStatus struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      desktop: payload["desktop"],
      mobile: payload["mobile"],
      web: payload["web"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.ClientStatus do
  alias Discordex.Types.Encodable

  def to_map(client_status) do
    %{}
    |> Encodable.Helpers.maybe_put(:desktop, client_status.desktop)
    |> Encodable.Helpers.maybe_put(:mobile, client_status.mobile)
    |> Encodable.Helpers.maybe_put(:web, client_status.web)
  end
end
