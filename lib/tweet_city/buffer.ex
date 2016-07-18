defmodule TweetCity.Buffer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Public API
  def add tweet do
    GenServer.cast(__MODULE__, {:add, tweet})
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  # GenServer API
  def handle_cast({:add, tweet}, state) when length(state) >= 100 do
    {:noreply, List.delete_at( [tweet | state], -1 )}
  end
  def handle_cast({:add, tweet}, state), do: {:noreply, [ tweet | state ]}

  def handle_call(:get, _from, [tweet | t] = state), do: {:reply, tweet, state}
  def handle_call(:get, _from, [tweet] = state), do: {:reply, tweet, state}
  def handle_call(:get, _from, []), do: {:reply, nil, []}

  def handle_call(:pop, _from, [tweet | t] = state), do: {:reply, tweet, t}
  def handle_call(:pop, _from, [tweet] = state), do: {:reply, tweet, []}
  def handle_call(:pop, _from, []), do: {:reply, nil, []}

  def handle_call(:get_all, _from, state), do: {:reply, state, state}
end
