import Config

config :mini_spider, MiniSpider.Repo,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "127.0.0.1",
  port: "5432"

config :mini_spider, Oban,
  repo: MiniSpider.Repo,
  plugins: false,
  queues: false
