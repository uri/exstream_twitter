defmodule ExstreamTwitter.StreamSupervisor do
  use Supervisor

  def start_link(filter_params) do
    Supervisor.start_link( __MODULE__, filter_params )
  end

  def init(filter_params) do
    children = [
      worker(ExstreamTwitter.Throttler, []),
      worker(ExstreamTwitter.Buffer, []),
      worker(ExstreamTwitter.Stream, [filter_params]),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
