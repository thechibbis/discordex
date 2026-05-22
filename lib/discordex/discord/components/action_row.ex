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
      components:
        action_row.components
        |> maybe_put(:id, action_row.id)
    }
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
