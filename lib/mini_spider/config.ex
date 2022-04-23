defmodule MiniSpider.Config do
  def oban_config() do
    Application.fetch_env!(:mini_spider, Oban)
  end

  def http_config() do
    [
      pools: %{
        :default => [size: 10]
      }
    ]
  end
end
