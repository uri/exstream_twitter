# TweetCity
### Property of
![logo-colour](https://cloud.githubusercontent.com/assets/566763/16632534/7a8fc45a-4392-11e6-9347-a5d77f135d63.png)

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

&copy; Fullscript
