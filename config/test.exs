import Config

config :mini_spider, MiniSpider.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "127.0.0.1",
  port: System.get_env("POSTGRES_PORT") || "5432"

config :mini_spider, Oban,
  repo: MiniSpider.Repo,
  plugins: false,
  queues: false
