defmodule Fmcsa.Company.Server do
  require Logger

  use GenServer
  alias Marshall

  @name __MODULE__
  @registry_name :company_registry

  defstruct name: nil,
            profile: nil,
            status: "init"

  def start_link(data) do
    name = via_tuple(data)

    GenServer.start_link(__MODULE__, [data], name: name)
  end

  def fetch_profile(data) do
    {name, url} = data
    GenServer.call(via_tuple(name), {:fetch, url})
  end

  def show_profile(data) do
    {name, url} = data
    GenServer.cast(via_tuple(name), :show_state)
  end

  def handle_call(:show_state, _from, state) do
    {:reply, state, state}
  end

  defp via_tuple(data) do
    {:via, Registry, {@registry_name, data}}
  end

  def init([args]) do
    {name, url} = args

    {:ok, %__MODULE__{}}
  end

  def handle_call({:fetch, url}, _from, state) do
    profile = Marshall.fetch_company_profile(url)
    updated_state = %__MODULE__{state | profile: profile}
    {:reply, profile, updated_state}
  end
end
