defmodule Discordex.Discord.DefaultValue do
  @enforce_keys [:id, :type]
  defstruct [:id, :type]

  @type value_type :: :user | :role | :channel

  @type t :: %__MODULE__{
    id: String.t(),
    type: value_type()
  }
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.DefaultValue do
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
