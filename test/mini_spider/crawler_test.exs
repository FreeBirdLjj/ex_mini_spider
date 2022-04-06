defmodule MiniSpider.CrawlerTest do
  use MiniSpider.DataCase, async: true
  doctest MiniSpider.Crawler

  use Oban.Testing, repo: MiniSpider.Repo

  describe "crawl/4" do
    test "should succeed" do
      url = "https://localhost"
      interval = :timer.seconds(10)
      storage_engine = MiniSpider.Storage.Local
      dir = "localhost"
      path_method = :original

      MiniSpider.Crawler.crawl(url, interval, storage_engine, dir: dir, path_method: path_method)

      assert_enqueued(
        worker: MiniSpider.Crawler.Worker,
        args: %{
          url: url,
          interval: interval,
          storage:
            MiniSpider.Crawler.Args.encode_storage_params(storage_engine,
              dir: dir,
              path_method: path_method
            )
        }
      )
    end
  end
end
