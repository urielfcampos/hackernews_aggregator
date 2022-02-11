defmodule HackerNewsAggregatorEx.Api.Controllers.Story do
  import Plug.Conn
  alias HackerNewsAggregatorEx.DB

  def show(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    handle_response(conn, load_story(id))
  end

  defp handle_response(conn, {:error, reason}) do
    error = %{error: reason} |> Jason.encode!()

    respond(conn, 404, error)
  end

  defp handle_response(conn, {:ok, story}) do
    story = Jason.encode!(story)
    respond(conn, 200, story)
  end

  defp load_story(id) do
    case DB.get_story(id) do
      nil ->
        {:error, :no_story}

      story ->
        {:ok, story}
    end
  end

  defp respond(conn, status, content) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, content)
  end
end
