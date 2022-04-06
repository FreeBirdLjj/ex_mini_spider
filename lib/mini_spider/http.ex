defmodule MiniSpider.HTTP do
  def child_spec(opts) do
    [
      name: __MODULE__
    ]
    |> Keyword.merge(opts)
    |> Finch.child_spec()
  end

  @spec get(Finch.Request.url(), keyword()) :: {:ok, Finch.Response.t()} | {:error, Exception.t()}
  def get(url, opts \\ []) do
    Finch.build(:get, url, [], nil)
    |> Finch.request(__MODULE__, opts)
  end
end
