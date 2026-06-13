# DiscordEx

WIP WIP WIP: DiscordEx is an unofficial Discord library for Elixir.

Besides being a learning project for me, I want to migrate my current discord bots to this library when it reaches an "usable" state.

My future goal is to evolve this to a framework that makes it easy to build discord bots in Elixir.

## What we have so far

### Gateway (WebSocket)

Start a bot connected to Discord's gateway:

```elixir
config :discordex,
  token: "your-bot-token",
  intents: [:guilds],
  consumer: MyApp.MyConsumer,
  name: MyApp.Bot
```

Then implement `Discordex.Consumer` callbacks in `MyApp.MyConsumer`.

### REST API

Register slash commands via Discord's HTTP API. No extra config needed —
the application ID is automatically discovered.

```elixir
config :discordex,
  token: "your-bot-token",
  intents: [:guilds],
  consumer: MyApp.MyConsumer,
  name: MyApp.Bot
```

From a consumer callback (e.g. `handle_ready/2` or an interaction handler):

```elixir
alias Discordex.Types.ApplicationCommand

command = %ApplicationCommand{
  name: "ping",
  description: "Replies with pong",
  type: :chat_input
}

Discordex.Rest.create_global_command(client.name, command)
# => {:ok, %ApplicationCommand{id: "987654321", ...}}
```