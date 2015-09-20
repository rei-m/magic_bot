defmodule MagicBot do
  use Application

  def start(_type, _args) do
    MagicBot.Supervisor.start_link
  end
end
