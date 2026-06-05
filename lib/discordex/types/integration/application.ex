defmodule Discordex.Types.Integration.Application do
  @moduledoc """
  Discord Integration Application object.

  See: https://docs.discord.com/developers/resources/guild#integration-application-object
  """

  alias Discordex.Types.User

  @enforce_keys [:id, :name, :description]
  defstruct [:id, :name, :icon, :description, :summary, :bot]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          icon: String.t() | nil,
          description: String.t(),
          summary: String.t() | nil,
          bot: User.t() | nil
        }

  @doc """
  Decodes a raw map into an Application struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      name: payload["name"],
      icon: payload["icon"],
      description: payload["description"],
      summary: payload["summary"],
      bot: decode_bot(payload["bot"])
    }
  end

  defp decode_bot(nil), do: nil
  defp decode_bot(bot_map), do: User.decode(bot_map)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Integration.Application do
  alias Discordex.Types.Encodable

  def to_map(app) do
    %{}
    |> Map.put(:id, app.id)
    |> Map.put(:name, app.name)
    |> Encodable.Helpers.maybe_put(:icon, app.icon)
    |> Map.put(:description, app.description)
    |> Encodable.Helpers.maybe_put(:summary, app.summary)
    |> maybe_put_bot(app.bot)
  end

  defp maybe_put_bot(map, nil), do: map
  defp maybe_put_bot(map, bot), do: Map.put(map, :bot, Encodable.to_map(bot))
end
