defmodule Fmcsa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Fmcsa.Worker.start_link(arg)
      # {Fmcsa.Worker, arg},
      supervisor(Registry, [:unique, :company_registry], id: :company_registry),
      supervisor(Fmcsa.Company.Supervisor, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fmcsa.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
