defmodule MiniSpider.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      {MiniSpider.HTTP, http_config()},
      MiniSpider.Repo,
      {Oban, oban_config()}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MiniSpider.Supervisor)
  end

  # Conditionally disable queues or plugins here.
  defp oban_config do
    Application.fetch_env!(:mini_spider, Oban)
  end

  defp http_config do
    [
      pools: %{
        :default => [size: 10]
      }
    ]
  end
end
