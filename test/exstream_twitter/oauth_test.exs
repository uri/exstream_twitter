defmodule ExstreamTwitter.OauthTest do
  use ExUnit.Case
  alias ExstreamTwitter.Oauth
  import Oauth
  doctest Oauth

  test "has the correct headers" do
    System.put_env "consumer_secret", "consumer_secret123123"
    System.put_env "oauth_token_secret", "oauth_token_secret123123"

    h = header([method: "POST", url: "https://urigorelik.com/", query: ""])

    assert String.length(h[:oauth_nonce]) == 32
    assert h[:oauth_consumer]         != nil
    assert h[:oauth_signature]        != nil
    assert h[:oauth_signature_method] != nil
    assert h[:oauth_timestamp]        != nil
  end

end
