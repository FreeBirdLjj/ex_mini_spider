defmodule MiniSpider.Repo do
  use Ecto.Repo,
    otp_app: :mini_spider,
    adapter: Ecto.Adapters.Postgres
end
