defmodule Discordex.Types.Interaction.Data do
  @moduledoc """
  Interaction data payload. The structure varies by interaction type.

  See: https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-data
  """

  alias __MODULE__.{ApplicationCommand, MessageComponent, ModalSubmit}

  @type t :: ApplicationCommand.t() | MessageComponent.t() | ModalSubmit.t()
end
