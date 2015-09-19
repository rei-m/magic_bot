defmodule MagicBot.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  # Define alias of process name
  @bot_name MagicBot.Bot

  def init(:ok) do

    # Get API Key of Slack
    api_key = case System.get_env("MAGICBOT_API_KEY") do
      nil -> Application.get_env(:MagicBot, :api_key)
      s -> s
    end

    # Make child process
    children = [
      worker(MagicBot.Bot, [api_key, [name: @bot_name]]),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
