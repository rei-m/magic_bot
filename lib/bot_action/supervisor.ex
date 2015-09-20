defmodule BotAction.Supervisor do

  @moduledoc """
  This module specifies supervisor of Bot Action.
  """

  @doc """
  Start supervisor of Bot Action.
  """
  def start_link(opts \\ []) do
    Task.Supervisor.start_link(opts)
  end

  @doc """
  Make new process of bot action.The process is supervised by Task.Supervisor.
  """
  def start_action(supervisor, command, trigger, message, slack) do
    Task.Supervisor.start_child(supervisor, fn ->
      case command do
        :respond -> BotAction.Action.respond(trigger, message, slack)
        :hear -> BotAction.Action.hear(trigger, message, slack)
      end
    end)
  end

end
