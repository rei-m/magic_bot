defmodule MagicBot do

  @moduledoc """
  This module specifies application of magic bot.
  """

  use Application

  @doc """
  Start supervisor of MagicBot.
  """
  def start(_type, _args) do
    MagicBot.Supervisor.start_link
  end

end
