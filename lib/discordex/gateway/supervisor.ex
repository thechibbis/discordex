defmodule Discordex.Gateway.Supervisor do
  use DynamicSupervisor

  def start_link(opts) do
    client = Keyword.fetch!(opts, :client)
    DynamicSupervisor.start_link(__MODULE__, opts, client: client, name: via_tuple(client.name))
  end

  def start_shard(supervisor_name, shard_id, client, total_shards, consumer) do
    spec = {
      Discordex.Gateway.Shard,
      client: client, shard_id: shard_id, total_shards: total_shards, consumer: consumer
    }

    DynamicSupervisor.start_child(via_tuple(supervisor_name), spec)
  end

  def count_children(supervisor_name) do
    DynamicSupervisor.count_children(via_tuple(supervisor_name))
  end

  @impl true
  def init(_client) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp via_tuple(client_name) do
    Module.concat(client_name, GatewaySupervisor)
  end
end
