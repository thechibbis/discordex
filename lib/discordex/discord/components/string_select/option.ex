defmodule Discordex.Discord.Components.StringSelect.Option do
  @enforce_keys [:label, :value]
  defstruct [:label, :value, :description, :emoji, :default]

  @type t :: %__MODULE__{
          value: String.t(),
          label: String.t(),
          description: String.t() | nil,
          emoji: Discordex.Discord.Emoji.t() | nil,
          default: boolean() | nil
        }
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.StringSelect.Option do
  def to_map(option) do
    %{
      label: option.label,
      value: option.value,
      description: option.description,
      emoji: nil,
      default: option.default
    }
  end
end
