defmodule HackerNewsAggregatorEx.DB do
  use Agent

  def start_link(initial_state) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def get_current_state do
    Agent.get(__MODULE__, & &1)
  end

  def set_state(new_state) do
    Agent.update(__MODULE__, fn _state -> new_state end)
    notify_clients()
  end

  def get_story(id) do
    current_state = get_current_state()
    id = String.to_integer(id)

    case current_state do
      [] ->
        nil

      state ->
        List.flatten(state.pages)
        |> Enum.find(fn story ->
          story["id"] == id
        end)
    end
  end

  def get_all_stories do
    current_state = get_current_state()

    case current_state do
      [] ->
        nil

      state ->
        List.flatten(state.pages)
    end
  end

  def notify_clients do
    stories = get_all_stories() |> Jason.encode!()

    Registry.HackerNewsAggregatorEx
    |> Registry.dispatch("/ws/top_stories", fn entries ->
      for {pid, _} <- entries do
        Process.send(pid, stories, [])
      end
    end)
  end
end
