defmodule TweetCity.StreamSupervisor do
  use Supervisor

  def start_link(filter_params) do
    Supervisor.start_link( __MODULE__, filter_params )
  end

  def init(filter_params) do
    children = [
      worker(TweetCity.Throttler, []),
      worker(TweetCity.Buffer, []),
      worker(TweetCity.Stream, [filter_params]),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
