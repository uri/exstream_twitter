defmodule TweetCity.Tweet do
  defstruct source: "", friends_count: nil, followers_count: nil, text: ""

  defdelegate parse!( chunk ), to: Poison.Parser

  def decode( chunk ) do
    Poison.decode!( chunk, as: %TweetCity.Tweet{} )
  end

  def stream do
    get_tweet = fn ->
      try do
        tweet =  TweetCity.Buffer.pop |> TweetCity.Parser.decode
        tweet
      rescue
        anything -> nil
      end
    end

    Stream.unfold(nil, fn
       n -> {get_tweet.(), nil}
    end)
    |> Stream.filter( fn e -> e != nil end )
  end

  def simple_stream do
    stream |> Stream.map fn tweet -> tweet.text end
  end
end
