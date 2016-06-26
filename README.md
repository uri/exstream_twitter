# TweetCity

## Usage

Change the keys in config.exs or set the appropriate environment variables:

```bash
	env consumer_secret="xxxx" \
		consumer_key="xxxx"  \
		oauth_token="xxxx" \
		oauth_token_secret="xxxx" \
		iex -S mix
```

Then in `iex`

```iex
TweetCity.Stream.start_link
```
