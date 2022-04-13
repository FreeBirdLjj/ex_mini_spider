defmodule MiniSpider.Storage.Mem do
  @behaviour MiniSpider.Storage

  @type store_opt :: {:ets_table, :ets.tab()}

  @impl MiniSpider.Storage
  def store(uri, content, opts) do
    with(
      {:ok, %{ets_table: ets_table}} <- extract_store_opts(opts),
      true <- :ets.insert(ets_table, {URI.to_string(uri), content})
    ) do
      :ok
    end
  end

  defp extract_store_opts(opts) do
    opt_map = Map.new(opts)

    with(
      {:ok, ets_table} <-
        MiniSpider.Storage.Options.retrieve_typed_option(
          opt_map,
          :ets_table,
          ":ets table",
          &(is_atom(&1) or is_reference(&1))
        )
    ) do
      {:ok, %{ets_table: ets_table}}
    end
  end
end
