defmodule ExstreamTwitter.Tweet do
  defstruct source: "", friends_count: nil, followers_count: nil, text: ""

  @doc """
  Returns a stream of %ExstreamTwitter.Tweet{}
  """
  def stream do
    Stream.unfold(nil, fn
       n -> {get_tweet, nil}
    end)
    |> Stream.filter( fn e -> e != nil end )
  end

  @doc """
  Returns a stream of text corresponding to tweets.
  """
  def simple_stream do
    stream |> Stream.map fn tweet -> tweet.text end
  end

  @doc """
  Returns a stream of tweets that do not begin with `@` or `RT`
  """
  def simple_stream original: true do
    simple_stream
    |> Stream.reject(fn
       "RT" <> _rest -> true
       "@" <> _rest -> true
       _anything -> false
    end)
  end

  defp get_tweet do
    ExstreamTwitter.Buffer.pop |> decode
  end

  defp decode( nil ), do: nil
  defp decode( chunk ) do
    case Poison.decode( chunk, as: %ExstreamTwitter.Tweet{} ) do
      {:ok, tweet} -> tweet
      _error -> nil
    end
  end

end
