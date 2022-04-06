import Config

config :mini_spider,
  ecto_repos: [MiniSpider.Repo]

config :floki,
  html_parser: Floki.HTMLParser.Mochiweb

import_config "#{config_env()}.exs"
