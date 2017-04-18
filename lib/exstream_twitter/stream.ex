defmodule ExstreamTwitter.Stream do
  use GenServer
  require Logger, as: L
  alias ExstreamTwitter.Web

  @method "POST"
  @base_url "https://stream.twitter.com/1.1/statuses/filter.json"

  def start_link(body) do
    GenServer.start_link(__MODULE__, body, [])
  end

  def init(body) do
    params = [
    ]
    |> Web.percent_map

    body = Keyword.merge([
      stall_warnings: "true",
      language: "en",
    ], body)
    |> Web.percent_map

    authorization = ExstreamTwitter.Oauth.authorization(method: @method, url: @base_url, params: body ++ params)

    headers = [
      { "Accept", "application/json" },
      { "Authorization", authorization },
      { "Content-Type", "application/x-www-form-urlencoded" },
    ]

    L.debug "This is the authorization header"
    L.debug inspect( authorization )

    options = [
      params: params,
      # proxy: {"localhost", 8888},
      stream_to: self,
      timeout: :infinity,
      hackney: [:insecure, recv_timeout: :infinity]
    ]

    # Throttle
    throttle_amount = GenServer.call(ExstreamTwitter.Throttler, :query)
    Logger.debug "Throttling for #{throttle_amount}"
    Process.sleep throttle_amount * 1000

    worker = HTTPoison.post!(@base_url, {:form, body}, headers, options )

    {:ok, worker}
  end

  def handle_info(msg, state) do
    case msg do
      %HTTPoison.Error{} -> raise("Something went wrong")


      response = %HTTPoison.AsyncChunk{chunk: chunk} ->
        GenServer.cast(ExstreamTwitter.Throttler, :ok)
        ExstreamTwitter.Buffer.add(chunk)
        {:noreply, msg}
      _ -> {:noreply, ""}
    end
  end

  def terminate _reason, _state do
    GenServer.cast(ExstreamTwitter.Throttler, :error)
  end

  defp process_response_chunk( chunk ) do
    IO.puts chunk
    IO.puts String.duplicate "+", 80
  end
end
