defprotocol Discordex.Discord.Encodable do
  @spec to_map(t()) :: map()
  def to_map(component)
end
