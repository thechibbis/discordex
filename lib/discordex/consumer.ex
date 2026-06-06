defmodule Discordex.Consumer do
  @moduledoc """
  Behaviour for Discord gateway event consumers.

  Implement callbacks for the events your bot handles.
  All callbacks are optional — only define the ones you need.

  The `client` parameter is a `Discordex.Client` struct.
  """

  alias Discordex.Types.{Interaction, Message}

  # -- Interaction callbacks ------------------------------------------------

  @doc "PING interaction (type 1) — respond with PONG to acknowledge."
  @callback handle_ping(interaction :: Interaction.t(), client :: module()) ::
              :ok | {:error, term()}

  @doc "APPLICATION_COMMAND interaction (type 2) — slash commands and context menus."
  @callback handle_application_command(interaction :: Interaction.t(), client :: module()) ::
              :ok | {:error, term()}

  @doc "MESSAGE_COMPONENT interaction (type 3) — button, select menu, etc."
  @callback handle_message_component(interaction :: Interaction.t(), client :: module()) ::
              :ok | {:error, term()}

  @doc "APPLICATION_COMMAND_AUTOCOMPLETE interaction (type 4)."
  @callback handle_autocomplete(interaction :: Interaction.t(), client :: module()) ::
              :ok | {:error, term()}

  @doc "MODAL_SUBMIT interaction (type 5)."
  @callback handle_modal_submit(interaction :: Interaction.t(), client :: module()) ::
              :ok | {:error, term()}

  # -- Gateway event callbacks ----------------------------------------------

  @doc "READY — gateway connection established, session started."
  @callback handle_ready(ready_data :: map(), client :: module()) :: :ok | {:error, term()}

  @doc "MESSAGE_CREATE — a message was sent in a visible channel."
  @callback handle_message_create(message :: Message.t(), client :: module()) :: :ok | {:error, term()}

  @optional_callbacks handle_ping: 2,
                      handle_application_command: 2,
                      handle_message_component: 2,
                      handle_autocomplete: 2,
                      handle_modal_submit: 2,
                      handle_ready: 2,
                      handle_message_create: 2
end
