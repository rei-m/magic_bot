defmodule Scripts do
  use Slack

  require HTTPoison
  require Floki

  # Get LGTM Image from lgtm.in
  def hear("lgtm", message, slack) do
    HTTPoison.start
    case URI.encode("http://www.lgtm.in/g") |> HTTPoison.get do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
        |> Floki.find("#imageUrl")
        |> Floki.attribute("value")
        |> hd
        |> send_message(message.channel, slack)
      {_, _} -> nil
    end
  end

  # Don't remove. This is default pattern.
  def hear(_, _, _) do
  end

  def respond("エリクサーほしい？", message, slack) do
     send_message("エリクサーちょうだい！\nhttp://img.yaplog.jp/img/01/pc/2/5/2/25253/1/1354.jpg", message.channel, slack)
  end

  # Don't remove. This is default pattern.
  def respond(_, _, _) do
  end
end
