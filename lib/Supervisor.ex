defmodule Fmcsa.Company.Supervisor do
  use Supervisor

  @registry_name :company_registry

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start(id) do
    Supervisor.start_child(__MODULE__, [id])
  end

  def stop(id) do
    case Registry.lookup(@registry_name, id) do
      [] ->
        :ok

      [{pid, _}] ->
        Process.exit(pid, :shutdown)
        :ok
    end
  end

  def init(_) do
    children = [worker(Fmcsa.Company.Server, [], restart: :transient)]

    supervise(children, strategy: :simple_one_for_one)
  end
end
