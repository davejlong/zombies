defmodule ZombieAlerter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :zombie_alerter,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ZombieAlerter.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:cowboy, "~> 1.0.0"},
    {:ex_twilio, "~> 0.4.0"},
    {:ex_twiml, "~> 2.1.3"},
    {:plug, "~> 1.0"},
    {:poison, "~> 3.1.0"},
    {:remix, "~> 0.0.1", only: :dev}]
  end
end
