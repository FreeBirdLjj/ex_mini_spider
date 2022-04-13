defmodule MiniSpider.Storage.Local do
  @behaviour MiniSpider.Storage

  @type store_opt :: {:dir, String.t()} | {:path_method, :original | :sha256}

  @impl MiniSpider.Storage
  def store(uri, content, opts) do
    with(
      {:ok, %{dir: dir, path_method: path_method}} <- extract_store_opts(opts),
      uri_path = uri.path || "/",
      filepath = Path.join(dir, get_inner_filepath(uri_path, path_method)),
      :ok <- File.mkdir_p(Path.dirname(filepath)),
      :ok <- File.write(filepath, content, [:utf8])
    ) do
      :ok
    end
  end

  defp extract_store_opts(opts) do
    opt_map = Map.new(opts)

    with(
      {:ok, dir} <-
        MiniSpider.Storage.Options.retrieve_typed_option(
          opt_map,
          :dir,
          "string",
          &is_binary/1
        ),
      {:ok, path_method} <-
        MiniSpider.Storage.Options.retrieve_typed_option(
          opt_map,
          :path_method,
          "atom",
          &is_atom/1
        )
    ) do
      {:ok, %{dir: dir, path_method: path_method}}
    end
  end

  defp get_inner_filepath(uri_path, :original) do
    if String.ends_with?(uri_path, ".html") do
      uri_path
    else
      Path.join(uri_path, "index.html")
    end
  end

  defp get_inner_filepath(uri_path, :sha256) do
    :crypto.hash(:sha256, uri_path)
    |> Base.encode16()
    |> (&(&1 <> ".html")).()
  end
end
