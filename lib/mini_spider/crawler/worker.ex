defmodule MiniSpider.Crawler.Worker do
  use Oban.Worker,
    queue: :crawler,
    max_attempts: 3,
    unique: [keys: [:url], period: :timer.hours(24)]

  @spec enqueue(String.t(), non_neg_integer(), iodata(), keyword()) ::
          {:error, term()} | {:ok, Oban.Job.t()}
  def enqueue(url, interval, storage, opts \\ []) do
    %{url: url, interval: interval, storage: storage}
    |> new(opts)
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "url" => url,
          "interval" => interval,
          "storage" => storage
        },
        attempted_at: attempted_at
      }) do
    with(
      {:ok, storage} <- MiniSpider.Crawler.Args.decode_storage_params(storage),
      %{engine: storage_engine, opts: storage_opts} <- storage,
      {:ok, resp} <- crawl(url),
      :ok <- skip_non_html_url(url, resp.headers),
      {:ok, uri} <- URI.new(url),
      :ok <- storage_engine.store(uri, resp.body, storage_opts),
      :ok <-
        enqueue_decendent_jobs(
          uri,
          resp.body,
          attempted_at,
          interval,
          storage_engine,
          storage_opts
        )
    ) do
      {:ok, {:html_url, url}}
    end
  end

  @impl Oban.Worker
  def timeout(%Oban.Job{
        args: %{
          "interval" => interval
        }
      }) do
    interval
  end

  defp crawl(url) do
    with(
      {:ok, resp} <- MiniSpider.HTTP.get(url),
      :ok <- validate_resp_status(resp)
    ) do
      {:ok, resp}
    end
  end

  defp validate_resp_status(resp) do
    if 200 <= resp.status and resp.status < 300 do
      :ok
    else
      {:error, {:http, resp}}
    end
  end

  defp skip_non_html_url(url, resp_headers) do
    content_type = Keyword.get(resp_headers, :"Content-Type")

    if is_nil(content_type) or String.starts_with?(content_type, "text/html") do
      :ok
    else
      {:ok, {:non_html_url, url}}
    end
  end

  defp enqueue_decendent_jobs(uri, content, attempted_at, interval, storage_engine, storage_opts) do
    errs =
      content
      |> MiniSpider.HTML.get_decendent_urls()
      |> Enum.map(&URI.merge(uri, &1))
      |> Enum.filter(&(&1.host == uri.host))
      |> Enum.map(
        &enqueue(
          URI.to_string(&1),
          interval,
          MiniSpider.Crawler.Args.encode_storage_params(storage_engine, storage_opts),
          scheduled_at: DateTime.add(attempted_at, interval)
        )
      )
      |> Keyword.delete(:ok)

    if errs == [] do
      :ok
    else
      {:error, {:enqueue_decendent_jobs, errs}}
    end
  end
end
