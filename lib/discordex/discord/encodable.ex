defprotocol Discordex.Discord.Encodable do
  @spec to_map(t()) :: map()
  def to_map(component)
end

defmodule Discordex.Discord.Encodable.Helpers do
  @doc """
  Puts `value` under `key` only when `value` is not nil.
  Used to omit optional fields from serialized maps.
  """
  @spec maybe_put(map(), atom(), term()) :: map()
  def maybe_put(map, _key, nil), do: map
  def maybe_put(map, key, value), do: Map.put(map, key, value)
end