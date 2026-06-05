defmodule Discordex.Types.Attachment do
  @moduledoc """
  Discord Attachment object.

  See: https://docs.discord.com/developers/resources/message#attachment-object
  """

  defstruct [
    :id,
    :filename,
    :description,
    :content_type,
    :size,
    :url,
    :proxy_url,
    :height,
    :width,
    :ephemeral,
    :duration_secs,
    :waveform,
    :flags
  ]

  @type t :: %__MODULE__{
          id: String.t() | nil,
          filename: String.t() | nil,
          description: String.t() | nil,
          content_type: String.t() | nil,
          size: integer() | nil,
          url: String.t() | nil,
          proxy_url: String.t() | nil,
          height: integer() | nil,
          width: integer() | nil,
          ephemeral: boolean() | nil,
          duration_secs: float() | nil,
          waveform: String.t() | nil,
          flags: integer() | nil
        }

  @doc """
  Decodes a raw map into an Attachment struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      id: payload["id"],
      filename: payload["filename"],
      description: payload["description"],
      content_type: payload["content_type"],
      size: payload["size"],
      url: payload["url"],
      proxy_url: payload["proxy_url"],
      height: payload["height"],
      width: payload["width"],
      ephemeral: payload["ephemeral"],
      duration_secs: payload["duration_secs"],
      waveform: payload["waveform"],
      flags: payload["flags"]
    }
  end
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Attachment do
  def to_map(attachment) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:id, attachment.id)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:filename, attachment.filename)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:description, attachment.description)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:content_type, attachment.content_type)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:size, attachment.size)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:url, attachment.url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:proxy_url, attachment.proxy_url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:height, attachment.height)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:width, attachment.width)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:ephemeral, attachment.ephemeral)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:duration_secs, attachment.duration_secs)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:waveform, attachment.waveform)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:flags, attachment.flags)
  end
end
