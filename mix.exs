defmodule Discordex.MixProject do
  use Mix.Project

  def project do
    [
      app: :discordex,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Discordex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.5"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:gen_state_machine, git: "https://github.com/thechibbis/gen_state_machine.git"},
      {:websockex, "~> 0.5.1"}
    ]
  end
end
