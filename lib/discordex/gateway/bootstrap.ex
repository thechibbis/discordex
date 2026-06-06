defmodule Discordex.Gateway.Bootstrap do
  use GenServer

  def start_link(opts) do
    client = Keyword.fetch!(opts, :client)
    GenServer.start_link(__MODULE__, client)
  end

  @impl true
  def init(client) do
    Discordex.Gateway.Supervisor.start_shard(client.name, 0, client, nil, client.consumer)

    {:ok, %{client: client}}
  end
end
