defmodule HackerNewsAggregatorEx.SocketHandler do
  alias HackerNewsAggregatorEx.DB
  @behaviour :cowboy_websocket
  def init(request, _state) do
    state = %{registry_key: request.path}
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.HackerNewsAggregatorEx
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  def websocket_handle(_client, state) do
    all_stories = DB.get_all_stories() |> Jason.encode!()
    {:reply, {:text, all_stories}, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
