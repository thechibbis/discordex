defmodule Discordex do
  use Supervisor

  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)
    Supervisor.start_link(__MODULE__, opts, name: name)
  end

  @impl true
  def init(opts) do
    name = Keyword.fetch!(opts, :name)
    token = Keyword.fetch!(opts, :token)
    intents = Keyword.fetch!(opts, :intents)
    consumer = Keyword.fetch!(opts, :consumer)

    client = %Discordex.Client{
      name: name,
      token: token,
      intents: intents,
      consumer: consumer
    }

    children = [
      {Discordex.Gateway.Supervisor, client: client},
      {Discordex.Gateway.Bootstrap, client: client}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
