defmodule Discordex.Types.Activity do
  @moduledoc """
  Discord Activity object.

  See: https://docs.discord.com/developers/resources/activity#activity-object
  """

  alias __MODULE__.{Timestamps, Party, Assets, Secrets, ActivityEmoji, Buttons}

  defstruct [
    :name,
    :type,
    :url,
    :created_at,
    :timestamps,
    :application_id,
    :details,
    :state,
    :emoji,
    :party,
    :assets,
    :secrets,
    :instance,
    :flags,
    :buttons
  ]

  @type t :: %__MODULE__{
          name: String.t() | nil,
          type: integer() | nil,
          url: String.t() | nil,
          created_at: integer() | nil,
          timestamps: Timestamps.t() | nil,
          application_id: String.t() | nil,
          details: String.t() | nil,
          state: String.t() | nil,
          emoji: ActivityEmoji.t() | nil,
          party: Party.t() | nil,
          assets: Assets.t() | nil,
          secrets: Secrets.t() | nil,
          instance: boolean() | nil,
          flags: integer() | nil,
          buttons: [Buttons.t()] | nil
        }

  @doc """
  Decodes a raw map into an Activity struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      name: payload["name"],
      type: payload["type"],
      url: payload["url"],
      created_at: payload["created_at"],
      timestamps: decode_timestamps(payload["timestamps"]),
      application_id: payload["application_id"],
      details: payload["details"],
      state: payload["state"],
      emoji: decode_emoji(payload["emoji"]),
      party: decode_party(payload["party"]),
      assets: decode_assets(payload["assets"]),
      secrets: decode_secrets(payload["secrets"]),
      instance: payload["instance"],
      flags: payload["flags"],
      buttons: decode_buttons(payload["buttons"])
    }
  end

  defp decode_timestamps(nil), do: nil
  defp decode_timestamps(timestamps_map), do: Timestamps.decode(timestamps_map)

  defp decode_party(nil), do: nil
  defp decode_party(party_map), do: Party.decode(party_map)

  defp decode_assets(nil), do: nil
  defp decode_assets(assets_map), do: Assets.decode(assets_map)

  defp decode_secrets(nil), do: nil
  defp decode_secrets(secrets_map), do: Secrets.decode(secrets_map)

  defp decode_emoji(nil), do: nil
  defp decode_emoji(emoji_map), do: ActivityEmoji.decode(emoji_map)

  defp decode_buttons(nil), do: nil
  defp decode_buttons(buttons) when is_list(buttons), do: Enum.map(buttons, &Buttons.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Activity do
  alias Discordex.Types.Encodable

  def to_map(activity) do
    %{}
    |> Encodable.Helpers.maybe_put(:name, activity.name)
    |> Encodable.Helpers.maybe_put(:type, activity.type)
    |> Encodable.Helpers.maybe_put(:url, activity.url)
    |> Encodable.Helpers.maybe_put(:created_at, activity.created_at)
    |> maybe_put_timestamps(activity.timestamps)
    |> Encodable.Helpers.maybe_put(:application_id, activity.application_id)
    |> Encodable.Helpers.maybe_put(:details, activity.details)
    |> Encodable.Helpers.maybe_put(:state, activity.state)
    |> maybe_put_emoji(activity.emoji)
    |> maybe_put_party(activity.party)
    |> maybe_put_assets(activity.assets)
    |> maybe_put_secrets(activity.secrets)
    |> Encodable.Helpers.maybe_put(:instance, activity.instance)
    |> Encodable.Helpers.maybe_put(:flags, activity.flags)
    |> maybe_put_buttons(activity.buttons)
  end

  defp maybe_put_timestamps(map, nil), do: map
  defp maybe_put_timestamps(map, timestamps), do: Map.put(map, :timestamps, Encodable.to_map(timestamps))

  defp maybe_put_emoji(map, nil), do: map
  defp maybe_put_emoji(map, emoji), do: Map.put(map, :emoji, Encodable.to_map(emoji))

  defp maybe_put_party(map, nil), do: map
  defp maybe_put_party(map, party), do: Map.put(map, :party, Encodable.to_map(party))

  defp maybe_put_assets(map, nil), do: map
  defp maybe_put_assets(map, assets), do: Map.put(map, :assets, Encodable.to_map(assets))

  defp maybe_put_secrets(map, nil), do: map
  defp maybe_put_secrets(map, secrets), do: Map.put(map, :secrets, Encodable.to_map(secrets))

  defp maybe_put_buttons(map, nil), do: map
  defp maybe_put_buttons(map, buttons), do: Map.put(map, :buttons, Enum.map(buttons, &Encodable.to_map/1))
end
