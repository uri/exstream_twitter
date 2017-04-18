defmodule ExstreamTwitter.Web do
  def percent_map map do
    map
    |> Enum.map fn {k, v} -> { k |> to_string |> URI.encode_www_form, v |> to_string |> URI.encode_www_form } end
  end

  def form_format map do
  end
end
