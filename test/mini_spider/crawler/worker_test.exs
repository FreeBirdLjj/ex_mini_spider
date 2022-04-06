defmodule MiniSpider.Crawler.WorkerTest do
  use MiniSpider.DataCase, async: true
  doctest MiniSpider.Crawler.Worker

  use Oban.Testing, repo: MiniSpider.Repo

  require FakeServer

  describe "perform/1" do
    FakeServer.test_with_server "should succeed crawl current page and enqueue decendent jobs" do
      url = "http://#{FakeServer.address()}"
      interval = :timer.seconds(10)
      table = :ets.new(:buckets_registry, [:set, :public])
      storage_engine = MiniSpider.Storage.Mem

      storage_opts = [
        ets_table: table
      ]

      external_link = "http://example.com"

      html_pages = %{
        "/" => """
        <html>
        <body>
        <a href="page_a"></a>
        <a href="#{external_link}"></a>
        </body>
        </html>
        """
      }

      encoded_storage_params =
        MiniSpider.Crawler.Args.encode_storage_params(storage_engine, storage_opts)

      for {path, content} <- html_pages do
        FakeServer.route(
          path,
          FakeServer.Response.ok(content, %{"Content-Type" => "text/html; charset=utf-8"})
        )
      end

      assert {:ok, {:html_url, url}} ==
               perform_job(MiniSpider.Crawler.Worker, %{
                 url: url,
                 interval: interval,
                 storage: encoded_storage_params
               })

      assert_enqueued(
        worker: MiniSpider.Crawler.Worker,
        args: %{
          url: "http://#{FakeServer.address()}/page_a",
          interval: interval,
          storage: encoded_storage_params
        }
      )

      refute_enqueued(
        worker: MiniSpider.Crawler.Worker,
        args: %{
          url: external_link,
          interval: interval,
          storage: encoded_storage_params
        }
      )

      assert Keyword.values(:ets.lookup(table, "http://#{FakeServer.address()}")) == [
               html_pages["/"]
             ]
    end
  end
end
