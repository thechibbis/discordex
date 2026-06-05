defmodule Discordex.Types.DefaultValue do
  @enforce_keys [:id, :type]
  defstruct [:id, :type]

  @type value_type :: :user | :role | :channel

  @type t :: %__MODULE__{
    id: String.t(),
    type: value_type()
  }

  @doc """
  Decodes a raw map into a DefaultValue struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      type: decode_type(payload["type"])
    }
  end

  defp decode_type("user"), do: :user
  defp decode_type("role"), do: :role
  defp decode_type("channel"), do: :channel
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.DefaultValue do
  def to_map(dv) do
    %{
      id: dv.id,
      type: encode_type(dv.type)
    }
  end

  defp encode_type(:user), do: "user"
  defp encode_type(:role), do: "role"
  defp encode_type(:channel), do: "channel"
end
