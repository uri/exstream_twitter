defmodule TweetCity.Stream do
  use GenServer
  require Logger, as: L
  alias TweetCity.Web

  @method "POST"
  @base_url "https://stream.twitter.com/1.1/statuses/filter.json"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    params = [
    ]
    |> Web.percent_map

    body = [
      stall_warnings: "true",
      language: "en",
      track: "brexit",
    ]
    |> Web.percent_map

    authorization = TweetCity.Oauth.authorization(method: @method, url: @base_url, params: body ++ params)

    headers = [
      { "Accept", "application/json" },
      { "Authorization", authorization },
      { "Content-Type", "application/x-www-form-urlencoded" },
    ]

    L.debug "This is the authorization header"
    L.debug inspect( authorization )

    options = [
      params: params,
      proxy: {"localhost", 8888},
      stream_to: self,
      timeout: :infinity,
      hackney: [:insecure]
    ]

    # Throttle
    throttle_amount = GenServer.call(TweetCity.Throttler, :query)
    Logger.debug "Throttling for #{throttle_amount}"
    Process.sleep throttle_amount * 1000

    worker = HTTPoison.post!(@base_url, {:form, body}, headers, options )

    {:ok, worker}
  end

  def handle_info(msg, state) do
    case msg do
      %HTTPoison.Error{} -> raise("Something went wrong")


      response = %HTTPoison.AsyncChunk{chunk: chunk} ->
        GenServer.cast(TweetCity.Throttler, :ok)
        IO.inspect( response )
        IO.puts "*" |> String.duplicate 80
        {:noreply, msg}


      _ -> {:noreply, ""}
    end
  end

  def terminate _reason, _state do
    GenServer.cast(TweetCity.Throttler, :error)
  end

  defp process_response_chunk( chunk ) do
    IO.puts chunk
    IO.puts String.duplicate "+", 80
  end
end
