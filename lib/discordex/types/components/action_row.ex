defmodule Discordex.Types.Components.ActionRow do
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

defimpl Discordex.Types.Encodable, for: Discordex.Types.Components.ActionRow do
  def to_map(action_row) do
    %{
      type: 1,
      components: Enum.map(action_row.components, &Discordex.Types.Encodable.to_map/1)
    }
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, action_row.id)
  end

end
