defmodule Fmcsa.Company.Supervisor do
  use DynamicSupervisor

  alias Game.Bot.Supervisor, as: SUPERVISOR
  alias Fmcsa.Company.Server, as: SERVER

  @name __MODULE__

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  @registry_name :company_registry



  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: @name)
  end

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: @name)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end



  def start(id) do

    child_spec = {SERVER, id}

    DynamicSupervisor.start_child(@name, child_spec)
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


end
