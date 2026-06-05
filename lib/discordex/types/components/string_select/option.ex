defmodule Discordex.Types.Components.StringSelect.Option do
  @enforce_keys [:label, :value]
  defstruct [:label, :value, :description, :emoji, :default]

  @type t :: %__MODULE__{
          value: String.t(),
          label: String.t(),
          description: String.t() | nil,
          emoji: Discordex.Types.Emoji.t() | nil,
          default: boolean() | nil
        }
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Components.StringSelect.Option do
  alias Discordex.Types.Encodable

  def to_map(option) do
    %{
      label: option.label,
      value: option.value,
      description: option.description,
      default: option.default
    }
    |> Encodable.Helpers.maybe_put(:emoji, encode_emoji(option.emoji))
  end

  defp encode_emoji(nil), do: nil
  defp encode_emoji(emoji), do: Encodable.to_map(emoji)
end
