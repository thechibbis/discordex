defmodule Discordex.Types.Integration.Account do
  @moduledoc """
  Discord Integration Account object.

  See: https://docs.discord.com/developers/resources/guild#integration-account-object
  """

  @enforce_keys [:id, :name]
  defstruct [:id, :name]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }

  @doc """
  Decodes a raw map into an Account struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      name: payload["name"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Integration.Account do
  def to_map(account) do
    %{
      id: account.id,
      name: account.name
    }
  end
end
