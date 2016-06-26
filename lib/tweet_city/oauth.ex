defmodule TweetCity.Oauth do
  def authorization( request = [method: method, url: url, params: params] ) do
    header = create_header
    signature = create_signature( [ {:oauth, header} | request ] )

    [ {:oauth_signature, signature} | header ]
    |> Enum.sort
    |> format_header
  end

  @doc """
  Encodes in percent encoding and comma separated.

      iex> format_header([h1: "header"])
      ~s(OAuth h1="header")

      iex> format_header([h1: "header with spaces"])
      ~s(OAuth h1="header%20with%20spaces")

      iex> format_header([h1: "val1", h2: "val2"])
      ~s(OAuth h1="val1", h2="val2")
  """
  def format_header header do
    "OAuth " <>
    (for { k, v } <- header do
       encoded_key = k |> to_string |> URI.encode_www_form
       encoded_value = v |> to_string |> URI.encode_www_form
       encoded_key <> "=" <> ~s(") <> encoded_value <> ~s(")
    end
    |> Enum.join(", "))
  end


  @doc """
  This format does not surround the value in double quotes like `format_header`
  """
  def percent_encode data do
    for { k, v } <- data do
      encoded_key = k |> to_string |> URI.encode_www_form
      encoded_value = v |> to_string |> URI.encode_www_form
      encoded_key <> "=" <> encoded_value
    end
  end

  def create_header do
    [
      oauth_consumer_key: consumer_key,
      oauth_nonce: generate_nonce,
      oauth_signature_method: "HMAC-SHA1",
      oauth_timestamp: :os.system_time(:seconds),
      oauth_token: oauth_token,
      oauth_version: "1.0"
    ]
  end

  @doc """
  Generates a unique OAuth nonce.
  """
  def generate_nonce do
    nonce = :crypto.strong_rand_bytes(32) |> Base.encode64
    Regex.replace(~r([=+/]), nonce, "z")
  end

  def create_signature(request) do
    :crypto.hmac(:sha, signing_key, signing_base(request))
    |> Base.encode64
  end


  @doc """
  URL encodes the HTTP method, base URL, and query/body.

  The joins with non URL encoded ampersands.

      iex> signing_base(method: "GET", url: "http://my_url.com/", params: "status=what's up")
      "GET&http%3A%2F%2Fmy_url.com%2F&status%3Dwhat%27s+up"
  """
  def signing_base(oauth: oauth, method: method, url: url, params: params) do
    query =
      oauth ++ params
      |> percent_encode
      |> Enum.sort
      |> Enum.join("&")

    [
      method |> String.upcase,
      url |> URI.encode_www_form,
      query |> URI.encode_www_form,
    ]
    |> Enum.join("&")
  end


  @doc """
  The consumer secret joined by an ampersand ('&') with the oauth secret, encoded in HMAC-SHA1 base64.
  """
  def signing_key do
    (consumer_secret |> URI.encode_www_form) <> "&" <> (oauth_token_secret |> URI.encode_www_form)
  end
  defp consumer_secret, do: System.get_env("consumer_secret")
  defp oauth_token_secret, do: System.get_env("oauth_token_secret")
  defp consumer_key, do: System.get_env("consumer_key")
  defp oauth_token, do: System.get_env("oauth_token")
end
