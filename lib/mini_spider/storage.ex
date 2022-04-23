defmodule MiniSpider.Storage do
  @callback store(url :: URI.t(), content :: String.t(), opts :: keyword()) :: :ok | {:error, term}
end
