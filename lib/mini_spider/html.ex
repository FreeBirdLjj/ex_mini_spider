defmodule MiniSpider.HTML do
  @spec get_decendent_urls(String.t()) :: {:ok, list} | {:error, term()}
  def get_decendent_urls(content) do
    with({:ok, document} <- Floki.parse_document(content)) do
      {:ok, Floki.attribute(document, "a", "href")}
    end
  end
end
