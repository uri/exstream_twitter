defmodule TweetCity.StreamSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link( __MODULE__, :ok )
  end

  def init(_) do
    children = [
      worker(TweetCity.Throttler, []),
      worker(TweetCity.Buffer, []),
      worker(TweetCity.Stream, []),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
