defmodule Discordex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    token = Application.get_env(:discordex, :token)
    intents = Application.get_env(:discordex, :intents, [])
    consumer = Application.get_env(:discordex, :consumer)
    name = Application.get_env(:discordex, :name, Discordex)

    children = if token && consumer do
      [{Discordex, name: name, token: token, intents: intents, consumer: consumer}]
    else
      []
    end

    opts = [strategy: :one_for_one, name: Discordex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
