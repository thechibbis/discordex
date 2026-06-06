defmodule Discordex.Client do
  # @moduledoc """
  # Client functions for responding to Discord interactions.

  # Passed as the third argument to `Discordex.Consumer` callbacks so consumers
  # can acknowledge, respond, defer, and send modals/autocomplete results.
  # """

  # alias Discordex.Types.Interaction
  # alias Discordex.Types.Interaction.{CallbackType, Response}

  # @type t :: %__MODULE__{
  #         http: module(),
  #         application_id: String.t()
  #       }

  # defstruct [:http, :application_id]

  # @doc """
  # Creates an interaction response.

  # `type` is an atom from `CallbackType.t()` — e.g. `:pong`, `:channel_message_with_source`,
  # `:deferred_channel_message_with_source`, `:modal`, `:application_command_autocomplete_result`.

  # `data` is optional: a `CallbackMessage`, `CallbackModal`, or `CallbackAutocomplete` struct
  # (or a plain map). Omit for types that carry no data (`:pong`, `:deferred_*`).

  # Returns `:ok` on success, `{:error, reason}` on failure.
  # """
  # @spec create_response(t(), Interaction.t(), CallbackType.t(), struct() | map() | nil) ::
  #         :ok | {:error, term()}
  # def create_response(_client, _interaction, type, data \\ nil) do
  #   response = %Response{
  #     type: CallbackType.encode(type),
  #     data: encode_data(data)
  #   }

  #   # TODO: POST to interaction callback URL
  #   # client.http.post("/interactions/#{interaction.id}/#{interaction.token}/callback", response)
  #   _ = response
  #   :ok
  # end

  # defp encode_data(nil), do: nil
  # defp encode_data(%_{} = data) do
  #   Discordex.Types.Encodable.to_map(data)
  # end
  # defp encode_data(data) when is_map(data), do: data

  defstruct [:name, :token, :intents, :consumer]

  @type t :: %__MODULE__{
          name: atom(),
          token: String.t(),
          intents: [Discordex.Types.Intent.t()],
          consumer: module()
        }

end
