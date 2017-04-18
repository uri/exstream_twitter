defmodule ExstreamTwitter.Throttler.Macro do
  defmacro make_do_wait_time(type_throttle) do
    quote do
      {error_type, i} = unquote(type_throttle)
      initial_val = case error_type do
        :tcp -> 5000
        :throttle -> 60000
      end
      val = initial_val * exp(2, i)

      def do_wait_time( ^error_type, ^i), do: val
    end
  end

  defmacro make_do_wait_time(anything) do
    IO.puts "Inspecting:"
    IO.inspect(anything)
  end

  ### Util

  defp exp(2,r), do: :math.pow(2,r) |> round

end
