defmodule Discordex.Discord.Components.ActionRow do
  @enforce_keys [:components]
  defstruct [:id, :components]

  @type child ::
          Button.t()
          | StringSelect.t()
          | UserSelect.t()
          | RoleSelect.t()
          | MentionableSelect.t()
          | ChannelSelect.t()

  @type t :: %__MODULE__{
          id: integer() | nil,
          components: [
            child()
          ]
        }
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.ActionRow do
  def to_map(action_row) do
    %{
      type: 1,
      components: Enum.map(action_row.components, &Discordex.Discord.Encodable.to_map/1)
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, action_row.id)
  end

end
