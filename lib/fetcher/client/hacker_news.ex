defmodule HackerNewsAggregatorEx.Fetcher.HackerNews do
  use Tesla

  alias HackerNewsAggregatorEx.Utils

  plug(Tesla.Middleware.BaseUrl, "https://hacker-news.firebaseio.com/v0/")
  plug(Tesla.Middleware.Headers)
  plug(Tesla.Middleware.JSON)

  def get_top_stories do
    case get("/topstories.json") do
      {:ok, %{status: 200, body: body}} ->
        result =
          Enum.take(body, 50)
          |> Enum.map(&get_stories/1)

        Utils.paginate(result)

      {:ok, %{status: status}} ->
        {:error, status}
    end
  end

  def get_stories(id) do
    IO.puts("fetching story #{id}")

    case get("/item/#{id}.json") do
      {:ok, %{status: 200, body: body}} ->
        Map.put(body, :api_uri, "/story/#{id}")

      {:ok, %{status: status}} ->
        {:error, status}
    end
  end
end
