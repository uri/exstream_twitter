defmodule TweetCity.BufferTest do
  use ExUnit.Case, async: true
  import TweetCity.Buffer

  setup do
    {:ok, _pid} = TweetCity.Buffer.start_link
    {:ok, []}
  end

  test "get returns nil if nothing is present" do
    assert get == nil
  end

  test "get returns a tweet if it's present", context do
    add "tweet"
    assert get == "tweet"
  end

  test "pop will return nil if the buffer is empty" do
    assert pop == nil
  end

  test "pop will return first-in first-out" do
    add 1
    add 2
    assert pop == 2
  end

  test "keeps 100 elements" do
    for i <- (1..100) do
      add i
    end

    add "newest"
    assert get == "newest"
    all = GenServer.call(TweetCity.Buffer, :get_all)
    assert length(all) == 100
  end
end
