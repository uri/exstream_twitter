defmodule ExstreamTwitter.Buffer do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  # Public API
  def add tweet do
    Agent.update(__MODULE__, fn tweets -> [ tweet | tweets ] end)
  end

  def get do
    Agent.get(__MODULE__, fn [ h | tweets ] -> h end)
  end

  def pop do
    Agent.get_and_update(__MODULE__, fn
      [] -> {nil, []}
      [ tweet | tweets ] -> {tweet, tweets}
    end)
  end
end
