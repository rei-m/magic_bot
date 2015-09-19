defmodule MagicBot.Bot do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_message(message = %{type: "message", text: _}, slack, state) do
    trigger = String.split(message.text, ~r{ |　})
    case String.starts_with?(message.text, "<@#{slack.me.id}>: ") do
      true  -> Scripts.respond(Enum.fetch!(trigger, 1), message, slack)
      false -> Scripts.hear(hd(trigger), message, slack)
    end
    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end
end
