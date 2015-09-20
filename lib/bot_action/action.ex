defmodule BotAction.Action do

  # Get LGTM Image from lgtm.in
  def hear("lgtm", message, slack) do
    HTTPoison.start
    case URI.encode("http://www.lgtm.in/g") |> HTTPoison.get do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
        |> Floki.find("#imageUrl")
        |> Floki.attribute("value")
        |> hd
        |> send_message(message, slack)
      {_, _} -> nil
    end
  end

  # Don't remove. This is default pattern.
  def hear(_, _, _) do end

  def respond("ちくわ", message, slack) do
    HTTPoison.start
    case URI.encode(create_tiqav_search_api_url(message.text)) |> HTTPoison.get do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
        |> Poison.decode!
        |> pick_random
        |> create_tiqav_image_url
        |> send_message(message, slack)
      {_, _} -> nil
    end
  end

  def respond("エリクサーほしい？", message, slack) do
     send_message("エリクサーちょうだい！\nhttp://img.yaplog.jp/img/01/pc/2/5/2/25253/1/1354.jpg", message, slack)
  end

  # Don't remove. This is default pattern.
  def respond(_, _, _) do end

  defp send_message(text, message, slack) do
    Slack.send_message(text, message.channel, slack)
  end

  defp create_tiqav_search_api_url(text) do
    key = String.split(text, ~r{ |　})
      |> Enum.split(2)
      |> elem(1)
      |> Enum.join(",")
    "http://api.tiqav.com/search.json?q=#{key}"
  end

  defp pick_random(list) do
    :random.seed :os.timestamp
    Enum.at(list, :random.uniform(length(list)) - 1)
  end

  defp create_tiqav_image_url(json) do
    "http://tiqav.com/#{json["id"]}.#{json["ext"]}"
  end

end
