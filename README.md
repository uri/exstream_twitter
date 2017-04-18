# ExstreamTwitter

## Usage

1. Create a [twitter application](https://apps.twitter.com/)
1. Create a `dev.secret.exs` file in the `config/` folder. User `config/dev.secret.exs.example` as a reference.
1. Run with `iex -S mix`
1. Start the stream supervisor via `StreamSupervisor.start_link`
1. Use `Tweet.stream/0` to get an Elixir stream of tweet structs. Or use `Tweet.simple_stream` to get an elixir stream that only returns the text of a tweet.
