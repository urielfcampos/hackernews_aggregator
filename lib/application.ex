defmodule HackerNewsAggregatorEx.Application do
  use Application
  require Logger

  alias HackerNewsAggregatorEx.Api.Router
  alias HackerNewsAggregatorEx.Fetcher
  alias HackerNewsAggregatorEx.DB

  def start(_type, _args) do
    children = [
      {Plug.Cowboy,
       scheme: :http,
       plug: Router,
       options: [port: 3000]},
       Fetcher,
       DB
    ]

    opts = [strategy: :one_for_one, name: HackerNewsAggregatorEx.Supervisor]

    Logger.info("Starting API...")

    Supervisor.start_link(children, opts)
  end
end
