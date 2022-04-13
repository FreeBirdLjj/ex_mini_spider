defmodule MiniSpider.Crawler.Args do
  @spec encode_storage_params(module(), keyword()) :: iodata()
  def encode_storage_params(engine, opts \\ []) do
    %{
      engine: engine,
      opts: opts
    }
    |> :erlang.term_to_binary()
    |> :erlang.binary_to_list()
  end

  @spec decode_storage_params(iodata()) ::
          {:ok, %{engine: module(), opts: keyword()}} | {:error, term()}
  def decode_storage_params(data) do
    data
    |> :erlang.iolist_to_binary()
    |> :erlang.binary_to_term()
    |> validate_storage_params()
  end

  @spec validate_storage_params(map()) ::
          {:ok, %{engine: module(), opts: keyword()}} | {:error, term()}
  def validate_storage_params(params) do
    with(
      %{engine: engine, opts: opts} <- params,
      :ok <-
        if is_atom(engine) do
          :ok
        else
          {:error, ArgumentError.exception("`engine` should be a module().")}
        end,
      :ok <-
        if Keyword.keyword?(opts) do
          :ok
        else
          {:error, ArgumentError.exception("`opts` should be a keyword().")}
        end
    ) do
      {:ok, params}
    end
  end
end
