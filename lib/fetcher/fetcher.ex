defmodule HackerNewsAggregatorEx.Fetcher do
  use GenServer

  alias HackerNewsAggregatorEx.Fetcher.HackerNews
  alias HackerNewsAggregatorEx.DB

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_) do
    timer = schedule()

    {:ok, timer}
  end

  def handle_info(:fetch_stories, _state) do
    top_stories = HackerNews.get_top_stories()
    DB.set_state(top_stories)

    state = schedule()
    {:noreply, state}
  end

  def handle_call(:state, state) do
    {:reply, state, state}
  end

  def schedule do
    Process.send_after(self(), :fetch_stories, 5 * 60 * 1000)
  end
end
