case System.get_env("MAGICBOT_API_KEY") do
  nil -> Application.get_env(:MagicBot, :api_key)
  s -> s
end |> MagicBot.start_link([])
