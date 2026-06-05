defmodule Discordex.Types.EncodableTest do
  use ExUnit.Case, async: true

  alias Discordex.Types.Encodable
  alias Discordex.Types.Encodable.Helpers, as: E

  # -- Encodable.Helpers -----------------------------------------------------

  describe "Encodable.Helpers.maybe_put/3" do
    test "puts value when not nil" do
      assert E.maybe_put(%{}, :key, "val") == %{key: "val"}
    end

    test "omits nil value" do
      assert E.maybe_put(%{a: 1}, :key, nil) == %{a: 1}
    end
  end

  # -- Emoji -----------------------------------------------------------------

  describe "Emoji" do
    test "encodes id and name" do
      emoji = %Discordex.Types.Emoji{id: "123", name: "wave"}
      assert Encodable.to_map(emoji) == %{id: "123", name: "wave"}
    end

    test "encodes animated flag" do
      emoji = %Discordex.Types.Emoji{name: "wave", animated: true}
      assert Encodable.to_map(emoji) == %{name: "wave", animated: true}
    end

    test "omits nil fields" do
      emoji = %Discordex.Types.Emoji{}
      assert Encodable.to_map(emoji) == %{}
    end
  end

  # -- UnfurledMediaItem -----------------------------------------------------

  describe "UnfurledMediaItem" do
    test "encodes url" do
      media = %Discordex.Types.UnfurledMediaItem{url: "https://example.com/img.png"}
      assert Encodable.to_map(media) == %{url: "https://example.com/img.png"}
    end

    test "encodes attachment reference" do
      media = %Discordex.Types.UnfurledMediaItem{url: "attachment://game.zip"}
      assert Encodable.to_map(media) == %{url: "attachment://game.zip"}
    end
  end

  # -- DefaultValue ----------------------------------------------------------

  describe "DefaultValue" do
    test "encodes user type" do
      dv = %Discordex.Types.DefaultValue{id: "111", type: :user}
      assert Encodable.to_map(dv) == %{id: "111", type: "user"}
    end

    test "encodes role type" do
      dv = %Discordex.Types.DefaultValue{id: "222", type: :role}
      assert Encodable.to_map(dv) == %{id: "222", type: "role"}
    end

    test "encodes channel type" do
      dv = %Discordex.Types.DefaultValue{id: "333", type: :channel}
      assert Encodable.to_map(dv) == %{id: "333", type: "channel"}
    end
  end

  # -- ComponentType ---------------------------------------------------------

  describe "ComponentType" do
    alias Discordex.Types.Components.ComponentType

    test "encodes all types to correct integers" do
      assert ComponentType.encode(:action_row) == 1
      assert ComponentType.encode(:button) == 2
      assert ComponentType.encode(:string_select) == 3
      assert ComponentType.encode(:text_input) == 4
      assert ComponentType.encode(:user_select) == 5
      assert ComponentType.encode(:role_select) == 6
      assert ComponentType.encode(:mentionable_select) == 7
      assert ComponentType.encode(:channel_select) == 8
      assert ComponentType.encode(:section) == 9
      assert ComponentType.encode(:text_display) == 10
      assert ComponentType.encode(:thumbnail) == 11
      assert ComponentType.encode(:media_gallery) == 12
      assert ComponentType.encode(:file) == 13
      assert ComponentType.encode(:separator) == 14
      assert ComponentType.encode(:container) == 17
      assert ComponentType.encode(:label) == 18
    end

    test "decodes all integers back to atoms" do
      assert ComponentType.decode(1) == {:ok, :action_row}
      assert ComponentType.decode(2) == {:ok, :button}
      assert ComponentType.decode(5) == {:ok, :user_select}
      assert ComponentType.decode(14) == {:ok, :separator}
      assert ComponentType.decode(17) == {:ok, :container}
      assert ComponentType.decode(18) == {:ok, :label}
    end

    test "decode returns :error for unknown integer" do
      assert ComponentType.decode(999) == :error
    end
  end

  # -- ButtonStyle -----------------------------------------------------------

  describe "ButtonStyle" do
    alias Discordex.Types.Components.ButtonStyle

    test "encodes all styles" do
      assert ButtonStyle.encode(:primary) == 1
      assert ButtonStyle.encode(:secondary) == 2
      assert ButtonStyle.encode(:success) == 3
      assert ButtonStyle.encode(:danger) == 4
      assert ButtonStyle.encode(:link) == 5
      assert ButtonStyle.encode(:premium) == 6
    end

    test "decodes all styles" do
      assert ButtonStyle.decode(1) == {:ok, :primary}
      assert ButtonStyle.decode(5) == {:ok, :link}
      assert ButtonStyle.decode(6) == {:ok, :premium}
    end

    test "decode returns :error for unknown" do
      assert ButtonStyle.decode(99) == :error
    end
  end

  # -- ActionRow -------------------------------------------------------------

  describe "ActionRow" do
    alias Discordex.Types.Components.{ActionRow, Button}

    test "encodes with buttons" do
      {:ok, btn} = Button.interactive("ok", :primary, label: "OK")
      row = %ActionRow{components: [btn]}
      map = Encodable.to_map(row)

      assert map.type == 1
      assert is_list(map.components)
      assert length(map.components) == 1
      assert hd(map.components).type == 2
    end

    test "encodes optional id" do
      {:ok, btn} = Button.interactive("ok", :primary, label: "OK")
      row = %ActionRow{id: 42, components: [btn]}
      map = Encodable.to_map(row)

      assert map.id == 42
    end

    test "omits id when nil" do
      {:ok, btn} = Button.interactive("ok", :primary, label: "OK")
      row = %ActionRow{id: nil, components: [btn]}
      map = Encodable.to_map(row)

      refute Map.has_key?(map, :id)
    end
  end

  # -- Button ----------------------------------------------------------------

  describe "Button.Interactive" do
    alias Discordex.Types.Components.Button

    test "encodes primary button with label" do
      {:ok, btn} = Button.interactive("click_me", :primary, label: "Click Me")
      map = Encodable.to_map(btn)

      assert map.type == 2
      assert map.style == 1
      assert map.custom_id == "click_me"
      assert map.label == "Click Me"
      assert map.disabled == false
    end

    test "encodes danger button" do
      {:ok, btn} = Button.interactive("delete", :danger, label: "Delete", disabled: true)
      map = Encodable.to_map(btn)

      assert map.style == 4
      assert map.disabled == true
    end

    test "omits optional fields" do
      {:ok, btn} = Button.interactive("min", :secondary)
      map = Encodable.to_map(btn)

      refute Map.has_key?(map, :label)
      refute Map.has_key?(map, :emoji)
      refute Map.has_key?(map, :id)
    end
  end

  describe "Button.Link" do
    alias Discordex.Types.Components.Button

    test "encodes link button" do
      {:ok, btn} = Button.link("https://example.com", label: "Visit")
      map = Encodable.to_map(btn)

      assert map.type == 2
      assert map.style == 5
      assert map.url == "https://example.com"
      assert map.label == "Visit"
      refute Map.has_key?(map, :custom_id)
    end
  end

  describe "Button.Premium" do
    alias Discordex.Types.Components.Button

    test "encodes premium button" do
      {:ok, btn} = Button.premium("sku_123")
      map = Encodable.to_map(btn)

      assert map.type == 2
      assert map.style == 6
      assert map.sku_id == "sku_123"
      assert map.disabled == false
    end
  end

  # -- StringSelect ----------------------------------------------------------

  describe "StringSelect" do
    alias Discordex.Types.Components.{StringSelect, StringSelect.Option}

    test "encodes basic select" do
      opt = %Option{label: "Ant", value: "ant"}
      {:ok, sel} = StringSelect.new("bugs", [opt])
      map = Encodable.to_map(sel)

      assert map.type == 3
      assert map.custom_id == "bugs"
      assert map.min_values == 1
      assert map.max_values == 1
      assert map.disabled == false
      assert length(map.options) == 1
    end

    test "encodes select with placeholder and multi-values" do
      opts = [%Option{label: "A", value: "a"}, %Option{label: "B", value: "b"}]
      {:ok, sel} = StringSelect.new("multi", opts, placeholder: "Pick", min_values: 1, max_values: 5)
      map = Encodable.to_map(sel)

      assert map.placeholder == "Pick"
      assert map.min_values == 1
      assert map.max_values == 5
      assert length(map.options) == 2
    end

    test "omits optional placeholder" do
      {:ok, sel} = StringSelect.new("s", [%Option{label: "X", value: "x"}])
      map = Encodable.to_map(sel)

      refute Map.has_key?(map, :placeholder)
      refute Map.has_key?(map, :id)
    end
  end

  describe "StringSelect.Option" do
    alias Discordex.Types.Components.StringSelect.Option

    test "encodes option with label and value" do
      opt = %Option{label: "Ant", value: "ant"}
      map = Encodable.to_map(opt)

      assert map.label == "Ant"
      assert map.value == "ant"
    end

    test "encodes option with description and default" do
      opt = %Option{label: "Bee", value: "bee", description: "bzzz", default: true}
      map = Encodable.to_map(opt)

      assert map.description == "bzzz"
      assert map.default == true
    end
  end

  # -- UserSelect ------------------------------------------------------------

  describe "UserSelect" do
    alias Discordex.Types.Components.UserSelect

    test "encodes basic user select" do
      {:ok, sel} = UserSelect.new("pick_user")
      map = Encodable.to_map(sel)

      assert map.type == 5
      assert map.custom_id == "pick_user"
      assert map.min_values == 1
      assert map.max_values == 1
      assert map.disabled == false
    end

    test "encodes with placeholder and multi-values" do
      {:ok, sel} = UserSelect.new("users", placeholder: "Choose...", min_values: 1, max_values: 5)
      map = Encodable.to_map(sel)

      assert map.placeholder == "Choose..."
      assert map.max_values == 5
    end

    test "encodes with default values" do
      dv = %Discordex.Types.DefaultValue{id: "111", type: :user}
      {:ok, sel} = UserSelect.new("users", default_values: [dv])
      map = Encodable.to_map(sel)

      assert length(map.default_values) == 1
      assert hd(map.default_values) == %{id: "111", type: "user"}
    end

    test "omits default_values when empty" do
      {:ok, sel} = UserSelect.new("users")
      map = Encodable.to_map(sel)

      refute Map.has_key?(map, :default_values)
    end
  end

  # -- RoleSelect ------------------------------------------------------------

  describe "RoleSelect" do
    alias Discordex.Types.Components.RoleSelect

    test "encodes role select" do
      {:ok, sel} = RoleSelect.new("pick_role", placeholder: "Select role", max_values: 3)
      map = Encodable.to_map(sel)

      assert map.type == 6
      assert map.custom_id == "pick_role"
      assert map.placeholder == "Select role"
      assert map.max_values == 3
    end
  end

  # -- MentionableSelect -----------------------------------------------------

  describe "MentionableSelect" do
    alias Discordex.Types.Components.MentionableSelect

    test "encodes mentionable select" do
      {:ok, sel} = MentionableSelect.new("pick", placeholder: "Who?")
      map = Encodable.to_map(sel)

      assert map.type == 7
      assert map.custom_id == "pick"
      assert map.placeholder == "Who?"
    end
  end

  # -- ChannelSelect ---------------------------------------------------------

  describe "ChannelSelect" do
    alias Discordex.Types.Components.ChannelSelect

    test "encodes channel select with channel_types filter" do
      {:ok, sel} = ChannelSelect.new("notif_ch", channel_types: [0, 5])
      map = Encodable.to_map(sel)

      assert map.type == 8
      assert map.custom_id == "notif_ch"
      assert map.channel_types == [0, 5]
    end

    test "omits channel_types when not provided" do
      {:ok, sel} = ChannelSelect.new("ch")
      map = Encodable.to_map(sel)

      refute Map.has_key?(map, :channel_types)
    end

    test "omits channel_types when empty list" do
      {:ok, sel} = ChannelSelect.new("ch", channel_types: [])
      map = Encodable.to_map(sel)

      refute Map.has_key?(map, :channel_types)
    end
  end

  # -- TextInput -------------------------------------------------------------

  describe "TextInput" do
    alias Discordex.Types.Components.TextInput

    test "encodes short text input" do
      {:ok, input} = TextInput.new("name", :short, placeholder: "Your name")
      map = Encodable.to_map(input)

      assert map.type == 4
      assert map.style == 1
      assert map.custom_id == "name"
      assert map.placeholder == "Your name"
      assert map.required == true
    end

    test "encodes paragraph with min/max length" do
      {:ok, input} = TextInput.new("feedback", :paragraph, min_length: 100, max_length: 4000, required: false)
      map = Encodable.to_map(input)

      assert map.style == 2
      assert map.min_length == 100
      assert map.max_length == 4000
      assert map.required == false
    end

    test "encodes pre-filled value" do
      {:ok, input} = TextInput.new("bio", :paragraph, value: "Hello world")
      map = Encodable.to_map(input)

      assert map.value == "Hello world"
    end

    test "omits optional fields" do
      {:ok, input} = TextInput.new("field", :short)
      map = Encodable.to_map(input)

      refute Map.has_key?(map, :placeholder)
      refute Map.has_key?(map, :value)
      refute Map.has_key?(map, :min_length)
      refute Map.has_key?(map, :max_length)
    end
  end

  # -- TextDisplay -----------------------------------------------------------

  describe "TextDisplay" do
    alias Discordex.Types.Components.TextDisplay

    test "encodes text content" do
      {:ok, td} = TextDisplay.new("# Hello\nWorld")
      map = Encodable.to_map(td)

      assert map.type == 10
      assert map.content == "# Hello\nWorld"
    end

    test "encodes with optional id" do
      {:ok, td} = TextDisplay.new("hi", id: 5)
      map = Encodable.to_map(td)

      assert map.id == 5
    end

    test "omits id when nil" do
      {:ok, td} = TextDisplay.new("hi")
      map = Encodable.to_map(td)

      refute Map.has_key?(map, :id)
    end
  end

  # -- Thumbnail -------------------------------------------------------------

  describe "Thumbnail" do
    alias Discordex.Types.Components.Thumbnail
    alias Discordex.Types.UnfurledMediaItem

    test "encodes thumbnail with media" do
      media = %UnfurledMediaItem{url: "https://example.com/thumb.png"}
      {:ok, tn} = Thumbnail.new(media, description: "preview image")
      map = Encodable.to_map(tn)

      assert map.type == 11
      assert map.media == %{url: "https://example.com/thumb.png"}
      assert map.description == "preview image"
      assert map.spoiler == false
    end

    test "encodes spoiler thumbnail" do
      media = %UnfurledMediaItem{url: "https://example.com/spoiler.png"}
      {:ok, tn} = Thumbnail.new(media, spoiler: true)
      map = Encodable.to_map(tn)

      assert map.spoiler == true
    end

    test "omits description when nil" do
      media = %UnfurledMediaItem{url: "https://example.com/img.png"}
      {:ok, tn} = Thumbnail.new(media)
      map = Encodable.to_map(tn)

      refute Map.has_key?(map, :description)
    end
  end

  # -- MediaGallery ----------------------------------------------------------

  describe "MediaGallery" do
    alias Discordex.Types.Components.MediaGallery
    alias Discordex.Types.Components.MediaGallery.Item
    alias Discordex.Types.UnfurledMediaItem

    test "encodes gallery with items" do
      media = %UnfurledMediaItem{url: "https://example.com/1.png"}
      {:ok, item} = Item.new(media, description: "first")
      {:ok, gallery} = MediaGallery.new([item])
      map = Encodable.to_map(gallery)

      assert map.type == 12
      assert length(map.items) == 1
      assert hd(map.items).media == %{url: "https://example.com/1.png"}
      assert hd(map.items).description == "first"
      assert hd(map.items).spoiler == false
    end

    test "gallery item encodes spoiler" do
      media = %UnfurledMediaItem{url: "attachment://secret.png"}
      {:ok, item} = Item.new(media, spoiler: true)
      map = Encodable.to_map(item)

      assert map.spoiler == true
      refute Map.has_key?(map, :description)
    end
  end

  # -- File ------------------------------------------------------------------

  describe "File" do
    alias Discordex.Types.Components.File
    alias Discordex.Types.UnfurledMediaItem

    test "encodes file with attachment reference" do
      media = %UnfurledMediaItem{url: "attachment://game.zip"}
      {:ok, f} = File.new(media)
      map = Encodable.to_map(f)

      assert map.type == 13
      assert map.file == %{url: "attachment://game.zip"}
      assert map.spoiler == false
    end

    test "encodes spoiler file" do
      media = %UnfurledMediaItem{url: "attachment://secret.pdf"}
      {:ok, f} = File.new(media, spoiler: true)
      map = Encodable.to_map(f)

      assert map.spoiler == true
    end
  end

  # -- Separator -------------------------------------------------------------

  describe "Separator" do
    alias Discordex.Types.Components.Separator

    test "encodes default separator" do
      {:ok, sep} = Separator.new()
      map = Encodable.to_map(sep)

      assert map.type == 14
      assert map.divider == true
      assert map.spacing == 1
    end

    test "encodes large spacing without divider" do
      {:ok, sep} = Separator.new(divider: false, spacing: 2)
      map = Encodable.to_map(sep)

      assert map.divider == false
      assert map.spacing == 2
    end
  end

  # -- Container -------------------------------------------------------------

  describe "Container" do
    alias Discordex.Types.Components.{Container, TextDisplay}

    test "encodes container with children and accent color" do
      {:ok, td} = TextDisplay.new("inside")
      {:ok, cont} = Container.new([td], accent_color: 0x0ABBE7, spoiler: true)
      map = Encodable.to_map(cont)

      assert map.type == 17
      assert map.accent_color == 0x0ABBE7
      assert map.spoiler == true
      assert length(map.components) == 1
      assert hd(map.components).type == 10
      assert hd(map.components).content == "inside"
    end

    test "omits accent_color when nil" do
      {:ok, td} = TextDisplay.new("hi")
      {:ok, cont} = Container.new([td])
      map = Encodable.to_map(cont)

      refute Map.has_key?(map, :accent_color)
    end
  end

  # -- Section ---------------------------------------------------------------

  describe "Section" do
    alias Discordex.Types.Components.{Section, TextDisplay, Thumbnail}
    alias Discordex.Types.Components.Button
    alias Discordex.Types.UnfurledMediaItem

    test "encodes section with text children and thumbnail accessory" do
      {:ok, td1} = TextDisplay.new("# Title")
      {:ok, td2} = TextDisplay.new("Body text")
      media = %UnfurledMediaItem{url: "https://example.com/thumb.png"}
      {:ok, thumb} = Thumbnail.new(media)

      {:ok, sec} = Section.new([td1, td2], thumb)
      map = Encodable.to_map(sec)

      assert map.type == 9
      assert length(map.components) == 2
      assert map.accessory.type == 11
    end

    test "encodes section with button accessory" do
      {:ok, td} = TextDisplay.new("Click below")
      {:ok, btn} = Button.interactive("go", :primary, label: "Go")

      {:ok, sec} = Section.new([td], btn)
      map = Encodable.to_map(sec)

      assert map.accessory.type == 2
      assert map.accessory.style == 1
    end
  end

  # -- Label -----------------------------------------------------------------

  describe "Label" do
    alias Discordex.Types.Components.{Label, TextInput}

    test "encodes label wrapping a text input" do
      {:ok, input} = TextInput.new("feedback", :paragraph, placeholder: "Write...")
      {:ok, lbl} = Label.new("Your feedback", input, description: "Please be detailed")
      map = Encodable.to_map(lbl)

      assert map.type == 18
      assert map.label == "Your feedback"
      assert map.description == "Please be detailed"
      assert map.component.type == 4
      assert map.component.custom_id == "feedback"
    end

    test "omits description when nil" do
      {:ok, input} = TextInput.new("name", :short)
      {:ok, lbl} = Label.new("Name", input)
      map = Encodable.to_map(lbl)

      refute Map.has_key?(map, :description)
    end
  end
end
