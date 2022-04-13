defmodule MiniSpider.Crawler do
  @spec crawl(String.t(), :timer.time(), module(), keyword()) ::
          {:error, term()} | {:ok, Oban.Job.t()}
  def crawl(url, interval, storage_engine, storage_opts \\ []) do
    MiniSpider.Crawler.Worker.enqueue(
      url,
      interval,
      MiniSpider.Crawler.Args.encode_storage_params(storage_engine, storage_opts)
    )
  end
end
