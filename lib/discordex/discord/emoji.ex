defmodule Discordex.Discord.Emoji do
  defstruct [:id, :name, :animated]

  @type t :: %__MODULE__{
    id: String.t() | nil,
    name: String.t() | nil,
    animated: boolean() | nil
  }
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Emoji do
  def to_map(emoji) do
    %{}
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, emoji.id)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:name, emoji.name)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:animated, emoji.animated)
  end
end
