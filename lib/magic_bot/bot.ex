defmodule MagicBot.Bot do

  @moduledoc """
  This module specifies Slack Bot.
  """

  use Slack

  @doc """
  Callback of connect Slack.
  """
  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  @doc """
  Callback of receive message from Slack.
  """
  def handle_message(message = %{type: "message", text: _}, slack, state) do
    # get trigger of action
    trigger = String.split(message.text, ~r{ |　})
    
    case String.starts_with?(message.text, "<@#{slack.me.id}>: ") do
      # when receive message that is to Bot. For example "@bot foo"
      true -> BotAction.Supervisor.start_action(state[:sup_action], :respond, Enum.fetch!(trigger, 1), message, slack)
      # when receive message. For example "bar"
      false -> BotAction.Supervisor.start_action(state[:sup_action], :hear, hd(trigger), message, slack)
    end
    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end
end
