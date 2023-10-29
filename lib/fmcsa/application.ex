defmodule Fmcsa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Fmcsa.Worker.start_link(arg)
      # {Fmcsa.Worker, arg},

      {Registry, keys: :unique, name: :company_registry, id: :company_registry},
      {DynamicSupervisor, strategy: :one_for_one, name: Fmcsa.Company.Supervisor}
    ]

    Fmcsa.Telemetry.setup()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fmcsa.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
