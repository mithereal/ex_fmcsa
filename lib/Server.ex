defmodule Fmcsa.Company.Server do
  require Logger

  use GenServer

  @name __MODULE__
  @registry_name :company_registry
  @ten_seconds 10000
  @one_day 834_000

  defstruct name: nil,
            profile: nil,
            last_update: nil

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

    Process.send_after(self(), {:sync, url}, @ten_seconds)

    {:ok, %__MODULE__{}}
  end

  def handle_call({:fetch, url}, _from, state) do
    profile = Fmcsa.fetch_company_profile(url)
    updated_state = %__MODULE__{state | profile: profile}
    updated_state = %{updated_state | last_update:  DateTime.utc_now()}
    {:reply, profile, updated_state}
  end

  def handle_info({:sync, url}, state) do
    profile = Fmcsa.fetch_company_profile(url)
    updated_state = %__MODULE__{state | profile: profile}
    updated_state = %{updated_state | last_update:  DateTime.utc_now()}
    Process.send_after(self(), {:sync, url}, @one_day)
    {:noreply, updated_state}
  end
end
