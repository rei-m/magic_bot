MagicBot
========

Bot of Slack written by elixir.

## Description
- This application supervise Slack and Supervisor of actions. Actions are separated from process of Slack.
- This bot uses [Elixir-Slack](https://github.com/BlakeWilliams/Elixir-Slack/). Thanks a lot.

## Usage
- To add bot action, open `lib/bot_action/action.ex`.
- Bot action has two functions. `hear/3` and `respond/3`.

- For example, when bot listened 'hello', bot sends a message to Slack.

```
def hear("hello", message, slack) do
  send_message("Hello World !!", message, slack)
end
```

- For example, when bot received 'who', bot sends a message to Slack.

```
def respond("who", message, slack) do
  send_message("My name is bot.", message, slack)
end
```

## Install
1. Create Bot at Slack and get API Token.

2. Make `config/config.exs` or set environment `MAGICBOT_API_KEY` that has API token.

  - `config/config.exs`
  ```
  use Mix.Config
  config  :MagicBot,
    api_key: "Your API Token"
  ```

3. Run `mix run --no-halt`.Then `Connected as name
` will be displayed. Your bot can receive message from Slack.

## Licence

[MIT](https://github.com/rei-m/magic_bot/blob/master/LICENCE.txt)

## Author

[rei-m](https://github.com/rei-m)
