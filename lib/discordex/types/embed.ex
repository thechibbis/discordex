defmodule Discordex.Types.Embed do
  @moduledoc """
  Discord Embed object.

  See: https://docs.discord.com/developers/resources/message#embed-object
  """

  alias Discordex.Types.Embed.{
    Author,
    Field,
    Footer,
    Image,
    Provider,
    Thumbnail,
    Video
  }

  defstruct [
    :title,
    :type,
    :description,
    :url,
    :timestamp,
    :color,
    :footer,
    :image,
    :thumbnail,
    :video,
    :provider,
    :author,
    :fields
  ]

  @type t :: %__MODULE__{
    title: String.t() | nil,
    type: String.t() | nil,
    description: String.t() | nil,
    url: String.t() | nil,
    timestamp: String.t() | nil,
    color: integer() | nil,
    footer: Footer.t() | nil,
    image: Image.t() | nil,
    thumbnail: Thumbnail.t() | nil,
    video: Video.t() | nil,
    provider: Provider.t() | nil,
    author: Author.t() | nil,
    fields: [Field.t()] | nil
  }

  @doc """
  Decodes a raw map into an Embed struct.
  """
  @spec decode(map()) :: t()
  def decode(payload) when is_map(payload) do
    %__MODULE__{
      title: payload["title"],
      type: payload["type"],
      description: payload["description"],
      url: payload["url"],
      timestamp: payload["timestamp"],
      color: payload["color"],
      footer: decode_footer(payload["footer"]),
      image: decode_image(payload["image"]),
      thumbnail: decode_thumbnail(payload["thumbnail"]),
      video: decode_video(payload["video"]),
      provider: decode_provider(payload["provider"]),
      author: decode_author(payload["author"]),
      fields: decode_fields(payload["fields"])
    }
  end

  defp decode_footer(nil), do: nil
  defp decode_footer(footer_map), do: Footer.decode(footer_map)

  defp decode_image(nil), do: nil
  defp decode_image(image_map), do: Image.decode(image_map)

  defp decode_thumbnail(nil), do: nil
  defp decode_thumbnail(thumbnail_map), do: Thumbnail.decode(thumbnail_map)

  defp decode_video(nil), do: nil
  defp decode_video(video_map), do: Video.decode(video_map)

  defp decode_provider(nil), do: nil
  defp decode_provider(provider_map), do: Provider.decode(provider_map)

  defp decode_author(nil), do: nil
  defp decode_author(author_map), do: Author.decode(author_map)

  defp decode_fields(nil), do: nil
  defp decode_fields(fields_list), do: Enum.map(fields_list, &Field.decode/1)
end

defimpl Discordex.Types.Encodable, for: Discordex.Types.Embed do
  def to_map(embed) do
    %{}
    |> Discordex.Types.Encodable.Helpers.maybe_put(:title, embed.title)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:type, embed.type)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:description, embed.description)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:url, embed.url)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:timestamp, embed.timestamp)
    |> Discordex.Types.Encodable.Helpers.maybe_put(:color, embed.color)
    |> maybe_put_footer(embed.footer)
    |> maybe_put_image(embed.image)
    |> maybe_put_thumbnail(embed.thumbnail)
    |> maybe_put_video(embed.video)
    |> maybe_put_provider(embed.provider)
    |> maybe_put_author(embed.author)
    |> maybe_put_fields(embed.fields)
  end

  defp maybe_put_footer(map, nil), do: map
  defp maybe_put_footer(map, footer) do
    Map.put(map, :footer, Discordex.Types.Encodable.to_map(footer))
  end

  defp maybe_put_image(map, nil), do: map
  defp maybe_put_image(map, image) do
    Map.put(map, :image, Discordex.Types.Encodable.to_map(image))
  end

  defp maybe_put_thumbnail(map, nil), do: map
  defp maybe_put_thumbnail(map, thumbnail) do
    Map.put(map, :thumbnail, Discordex.Types.Encodable.to_map(thumbnail))
  end

  defp maybe_put_video(map, nil), do: map
  defp maybe_put_video(map, video) do
    Map.put(map, :video, Discordex.Types.Encodable.to_map(video))
  end

  defp maybe_put_provider(map, nil), do: map
  defp maybe_put_provider(map, provider) do
    Map.put(map, :provider, Discordex.Types.Encodable.to_map(provider))
  end

  defp maybe_put_author(map, nil), do: map
  defp maybe_put_author(map, author) do
    Map.put(map, :author, Discordex.Types.Encodable.to_map(author))
  end

  defp maybe_put_fields(map, nil), do: map
  defp maybe_put_fields(map, fields) do
    Map.put(map, :fields, Enum.map(fields, &Discordex.Types.Encodable.to_map/1))
  end
end
