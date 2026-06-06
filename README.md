# DiscordEx

WIP WIP WIP: DiscordEx is an unofficial Discord library for Elixir.

Besides being a learning project for me, I want to migrate my current discord bots to this library when it reaches an "usable" state.

My future goal is to evolve this to a framework that makes it easy to build discord bots in Elixir.

## What we have so far ?

if you run `iex -S mix` and then

```elixir
iex> {:ok, _pid} = Discordex.start_link(
             name: :my_bot,
             token: "your token",
             intents: [:guilds],
             consumer: MyApp.MyConsumer
           )
```

you can get an bot running!
