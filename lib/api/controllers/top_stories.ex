defmodule HackerNewsAggregatorEx.Api.Controllers.TopStories do
  import Plug.Conn

  alias HackerNewsAggregatorEx.DB

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _opts) do
    conn = fetch_query_params(conn)

    page =
      Map.get(conn.query_params, "page", "1")
      |> String.to_integer()

    handle_response(conn, load_stories(page))
  end

  defp load_stories(page) do
    case DB.get_current_state() do
      [] ->
        {:ok, []}

      %{} = stories ->
        fetch_page(page, stories)

      _ ->
        {:error, :unknown}
    end
  end

  defp fetch_page(page, stories) do
    case HackerNewsAggregatorEx.Utils.get_page(page, stories) do
      {:ok, page} ->
        {:ok, page}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp handle_response(conn, {:error, :page_not_found}) do
    response = %{error: :page_not_found, available: "1..5"} |> Jason.encode!()
    respond(conn, 404, response)
  end

  defp handle_response(conn, {:error, _}) do
    response = %{error: "unknown error"} |> Jason.encode!()
    respond(conn, 500, response)
  end

  defp handle_response(conn, {:ok, []}) do
    response = %{stories: []} |> Jason.encode!()
    respond(conn, 200, response)
  end

  defp handle_response(conn, {:ok, story}) do
    response = %{stories: story} |> Jason.encode!()
    respond(conn, 200, response)
  end

  defp respond(conn, status, content) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, content)
  end
end
