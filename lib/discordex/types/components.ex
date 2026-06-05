defmodule Discordex.Types.Components do
  alias Discordex.Types.Components.{
    ActionRow,
    Button,
    StringSelect,
    UserSelect,
    RoleSelect,
    MentionableSelect,
    ChannelSelect,
    TextInput,
    Section,
    TextDisplay,
    Thumbnail,
    MediaGallery,
    File,
    Separator,
    Container,
    Label
  }

  @type t ::
          ActionRow.t()
          | Button.t()
          | StringSelect.t()
          | UserSelect.t()
          | RoleSelect.t()
          | MentionableSelect.t()
          | ChannelSelect.t()
          | TextInput.t()
          | Section.t()
          | TextDisplay.t()
          | Thumbnail.t()
          | MediaGallery.t()
          | File.t()
          | Separator.t()
          | Container.t()
          | Label.t()
end
