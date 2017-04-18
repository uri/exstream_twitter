defmodule ExstreamTwitter.Throttler do
  use GenServer
  @name __MODULE__

  def start_link do
    GenServer.start_link(@name, 0, name: @name)
  end

  def handle_call :query, reply, state do
    {:reply, state, state}
  end

  def handle_cast :ok, state do
    {:noreply, 0}
  end
  def handle_cast :error, state do
    new_state =
      case state do
        n when n > 300 -> n
        n when n < 10 -> n + 10
        n -> :math.pow(n, 2) |> round
      end

    {:noreply, new_state}
  end
end
