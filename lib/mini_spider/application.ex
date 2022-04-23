defmodule MiniSpider.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      {MiniSpider.HTTP, MiniSpider.Config.http_config()},
      MiniSpider.Repo,
      {Oban, MiniSpider.Config.oban_config()}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MiniSpider.Supervisor)
  end
end
