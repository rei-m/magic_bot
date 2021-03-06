defmodule BotAction.Action do

  @moduledoc """
  This module specifies Bot Action.
  """

  @doc """
  When receive "lgtm".
  Bot send a image which searched from `lgtm.in`.

  For example "lgtm"
  """
  def hear("lgtm", message, ets, slack) do

    :ets.insert(ets, {:lgtm_called_count, get_lgtm_called_count(ets) + 1})

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

  @doc """
  Don't remove. This is default pattern.
  """
  def hear(_, _, _, _) do end

  @doc """
  When receive "ちくわ keyword".
  Bot send a image which searched from `tiqav.com`.

  For example "@your_bot ちくわ ドラゴンボール", Bot send a image of DragonBall
  """
  def respond("ちくわ", message, _, slack) do
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

  @doc """
  When receive "エリクサーほしい？".
  Bot send a message.

  For example "@your_bot エリクサーほしい？"
  """
  def respond("エリクサーほしい？", message, _, slack) do
    send_message("エリクサーちょうだい！\nhttp://img.yaplog.jp/img/01/pc/2/5/2/25253/1/1354.jpg", message, slack)
  end

  def respond("lgtmcount", message, ets, slack) do
    send_message("いまのとこ #{get_lgtm_called_count(ets)} 回のlgtm", message, slack)
  end

  @doc """
  Don't remove. This is default pattern.
  """
  def respond(_, _, _, _) do end

  # Bot send a message.
  defp send_message(text, message, slack) do
    Slack.send_message(text, message.channel, slack)
  end

  # Create url for search image from tiqav.
  defp create_tiqav_search_api_url(text) do
    key = String.split(text, ~r{ |　})
      |> Enum.split(2)
      |> elem(1)
      |> Enum.join(",")
    "http://api.tiqav.com/search.json?q=#{key}"
  end

  # Pick at random from list.
  defp pick_random(list) do
    :random.seed :os.timestamp
    Enum.at(list, :random.uniform(length(list)) - 1)
  end

  # Create url of image for response of tiqav.
  defp create_tiqav_image_url(json) do
    "http://tiqav.com/#{json["id"]}.#{json["ext"]}"
  end

  defp get_lgtm_called_count(ets) do
    case :ets.lookup(ets, :lgtm_called_count) do
      [] -> 0
      x -> x[:lgtm_called_count]
    end
  end

end
