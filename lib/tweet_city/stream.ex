defmodule TweetCity.Stream do
  require Logger, as: L
  use GenServer
  @base_url "https://stream.twitter.com/1.1/statuses/sample.json"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    authorization = TweetCity.Oauth.authorization(method: "GET", url: @base_url, params: [])

    headers = [
      { "Accept", "application/json" },
      { "Authorization", authorization },
      { "Content-Type", "application/x-www-form-urlencoded" },
    ]

    # proxy = {"localhost", 8888}
    worker = HTTPoison.get!(@base_url, headers, [stream_to: self, timeout: :infinity, hackney: [:insecure]])
    {:ok, worker}
  end

  def handle_info(msg, state) do
    IO.inspect {:handle_info, msg}
    {:noreply, state}
  end
end
