defmodule HackerNewsAggregatorEx.Api.Router do
  use Plug.Router

  alias HackerNewsAggregatorEx.Api.Controllers.TopStories
  alias HackerNewsAggregatorEx.Api.Controllers.Story

  plug(Plug.Logger)
  plug(:match)

  plug(:dispatch)

  get "/top_stories" do
    TopStories.index(conn, opts)
  end

  get "/story/:id" do
    Story.show(conn, opts)
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
