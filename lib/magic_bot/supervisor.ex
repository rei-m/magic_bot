defmodule MagicBot.Supervisor do

  @moduledoc """
  This module specifies supervisor of MagicBot.
  """

  use Supervisor

  @doc """
  Start supervisor of MagicBot.
  """
  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  # Define alias of process name
  @bot_name MagicBot.Bot
  @action_sup_name BotAction.Supervisor

  @doc """
  Callback of start_link.
  """
  def init(:ok) do

    # Get API Token of Slack.
    api_key = case System.get_env("MAGICBOT_API_KEY") do
      nil -> Application.get_env(:MagicBot, :api_key)
      s -> s
    end

    # Make child process
    children = [
      supervisor(BotAction.Supervisor, [[name: @action_sup_name]]),
      worker(MagicBot.Bot, [api_key, [name: @bot_name, sup_action: @action_sup_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end

end
