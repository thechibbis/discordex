defmodule Discordex.Dispatcher do
  require Logger
  @moduledoc """
  Routes decoded Discord gateway events to a consumer module's callbacks.

  ## Event flow

      raw JSON → decode → Dispatcher.dispatch(event_name, event_data, consumer, client)

  The `event_name` is a lowercase atom matching the Discord event type
  (e.g. `:interaction_create`, `:ready`, `:message_create`).

  ## Interaction sub-routing

  `INTERACTION_CREATE` events are further routed by `interaction.type`
  to the specific callback (`handle_ping`, `handle_application_command`, etc.).
  """

  alias Discordex.Types.Interaction

  @doc """
  Dispatches a decoded event to the matching callback on `consumer`.

  Returns `:ok` if handled, `{:error, :unhandled_event}` if no callback matches,
  or `{:error, reason}` if the callback returned an error.
  """
  @spec dispatch(atom(), term(), module(), module()) :: :ok | {:error, term()}

  # -- INTERACTION_CREATE (sub-routed by interaction type) ----------------

  def dispatch(:interaction_create, %Interaction{type: :ping} = interaction, consumer, client) do
    call_if_exported(consumer, :handle_ping, [interaction, client])
  end

  def dispatch(:interaction_create, %Interaction{type: :application_command} = interaction, consumer, client) do
    call_if_exported(consumer, :handle_application_command, [interaction, client])
  end

  def dispatch(:interaction_create, %Interaction{type: :message_component} = interaction, consumer, client) do
    call_if_exported(consumer, :handle_message_component, [interaction, client])
  end

  def dispatch(:interaction_create, %Interaction{type: :application_command_autocomplete} = interaction, consumer, client) do
    call_if_exported(consumer, :handle_autocomplete, [interaction, client])
  end

  def dispatch(:interaction_create, %Interaction{type: :modal_submit} = interaction, consumer, client) do
    call_if_exported(consumer, :handle_modal_submit, [interaction, client])
  end

  # -- Gateway events -----------------------------------------------------

  def dispatch(:ready, ready_data, consumer, client) do
    call_if_exported(consumer, :handle_ready, [ready_data, client])
  end

  def dispatch(:message_create, message, consumer, client) do
    call_if_exported(consumer, :handle_message_create, [message, client])
  end

  # -- Fallback -----------------------------------------------------------

  def dispatch(_event_name, _event_data, _consumer, _client) do
    {:error, :unhandled_event}
  end

  # -- Helpers ------------------------------------------------------------

  defp call_if_exported(consumer, fun, args) do
    arity = length(args)

    case Code.ensure_loaded(consumer) do
      {:module, ^consumer} ->
        if function_exported?(consumer, fun, arity) do
          apply(consumer, fun, args)
        else
          Logger.debug("[dispatcher] #{inspect(consumer)}.#{fun}/#{arity} not exported")
          {:error, :unhandled_event}
        end

      {:error, reason} ->
        Logger.warning("[dispatcher] #{inspect(consumer)} could not be loaded: #{inspect(reason)}")
        {:error, :unhandled_event}
    end
  end
end