defmodule Discordex.Discord.Components.Label do
  @moduledoc """
  Discord Label component.

  See: https://discord.com/developers/docs/interactions/message-components#label
  """

  alias Discordex.Discord.Components.{
    ChannelSelect,
    MentionableSelect,
    RoleSelect,
    StringSelect,
    TextInput,
    UserSelect
  }

  @enforce_keys [:label, :component]
  defstruct [:id, :label, :component, :description]

  @type child ::
          TextInput.t()
          | StringSelect.t()
          | UserSelect.t()
          | RoleSelect.t()
          | MentionableSelect.t()
          | ChannelSelect.t()

  @type t :: %__MODULE__{
    id: integer() | nil,
    label: String.t(),
    component: child(),
    description: String.t() | nil
  }

  @spec new(String.t(), child(), keyword()) :: {:ok, t()} | {:error, term()}
  def new(label, component, opts \\ [])

  def new(label, component, opts) when is_binary(label) and is_list(opts) do
    with :ok <- validate_label(label),
         :ok <- validate_description(opts[:description]) do
      {:ok,
       %__MODULE__{
         id: opts[:id],
         label: label,
         component: component,
         description: opts[:description]
       }}
    end
  end

  def new(_, _, _), do: {:error, :invalid_label}

  defp validate_label(value) when is_binary(value) and byte_size(value) >= 1 and byte_size(value) <= 45, do: :ok
  defp validate_label(_), do: {:error, :invalid_label_length}

  defp validate_description(nil), do: :ok
  defp validate_description(value) when is_binary(value) and byte_size(value) <= 100, do: :ok
  defp validate_description(_), do: {:error, :invalid_description}
end

defimpl Discordex.Discord.Encodable, for: Discordex.Discord.Components.Label do
  def to_map(label) do
    %{
      type: 18,
      label: label.label,
      component: Discordex.Discord.Encodable.to_map(label.component)
    }
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:id, label.id)
    |> Discordex.Discord.Encodable.Helpers.maybe_put(:description, label.description)
  end
end
