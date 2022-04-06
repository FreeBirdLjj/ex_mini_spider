defmodule MiniSpider.Storage do
  @callback store(URI.t(), String.t(), keyword()) :: :ok | {:error, term}
end
