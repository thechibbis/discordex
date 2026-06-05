defmodule Discordex.Types.User do
  @moduledoc """
  Discord User object.

  See: https://docs.discord.com/developers/resources/user#user-object
  """

  defstruct [
    :id,
    :username,
    :discriminator,
    :global_name,
    :avatar,
    :bot,
    :system,
    :mfa_enabled,
    :banner,
    :accent_color,
    :locale,
    :verified,
    :email,
    :flags,
    :premium_type,
    :public_flags,
    :avatar_decoration_data
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          username: String.t() | nil,
          discriminator: String.t() | nil,
          global_name: String.t() | nil,
          avatar: String.t() | nil,
          bot: boolean() | nil,
          system: boolean() | nil,
          mfa_enabled: boolean() | nil,
          banner: String.t() | nil,
          accent_color: integer() | nil,
          locale: String.t() | nil,
          verified: boolean() | nil,
          email: String.t() | nil,
          flags: integer() | nil,
          premium_type: integer() | nil,
          public_flags: integer() | nil,
          avatar_decoration_data: map() | nil
        }

  @doc """
  Decodes a raw map into a User struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      username: payload["username"],
      discriminator: payload["discriminator"],
      global_name: payload["global_name"],
      avatar: payload["avatar"],
      bot: payload["bot"],
      system: payload["system"],
      mfa_enabled: payload["mfa_enabled"],
      banner: payload["banner"],
      accent_color: payload["accent_color"],
      locale: payload["locale"],
      verified: payload["verified"],
      email: payload["email"],
      flags: payload["flags"],
      premium_type: payload["premium_type"],
      public_flags: payload["public_flags"],
      avatar_decoration_data: payload["avatar_decoration_data"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.User do
  def to_map(user) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, user.id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:username, user.username)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:discriminator, user.discriminator)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:global_name, user.global_name)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:avatar, user.avatar)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:bot, user.bot)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:system, user.system)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:mfa_enabled, user.mfa_enabled)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:banner, user.banner)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:accent_color, user.accent_color)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:locale, user.locale)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:verified, user.verified)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:email, user.email)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:flags, user.flags)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:premium_type, user.premium_type)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:public_flags, user.public_flags)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:avatar_decoration_data, user.avatar_decoration_data)
  end
end
