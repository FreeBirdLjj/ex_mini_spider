defmodule MiniSpider.HTML do
  @spec get_decendent_urls(String.t()) :: list | {:error, term()}
  def get_decendent_urls(content) do
    with({:ok, document} <- Floki.parse_document(content)) do
      document
      |> Floki.attribute("a", "href")
    end
  end
end
