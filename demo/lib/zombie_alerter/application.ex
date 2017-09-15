defmodule ZombieAlerter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, ZombieAlerter.Router, [], [ip: {0, 0, 0, 0}, port: 4000]),
      ZombieAlerter.Subscriptions.child_spec(nil)
    ]

    Logger.info "Starting Zombie Alerter, listening on 0.0.0.0:4000"

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ZombieAlerter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
