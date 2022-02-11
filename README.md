# HackerNewsAggregatorEx

This is a barebones API that fetches the 50 Top stories from the [Hacker News Api](https://github.com/HackerNews/API) and 
Publishes it as a REST and WebSocket Api

Available endpoints:

- `/top_stories` 
  - Returns 10 stories at time 
  - Available query param: `?pages=:number_of_page` between 1 and 5.
- `/story/:id`
  - Returns a single story that's included in the Top 50 stories.
- `/ws/top_stories`
  - WebSocket endpoint that responds with the Top 50 stories that are saved in memory.
  - Notifies users when new stories are requested.

The Fetcher client is implemented with a `GenServer` and fetches stories every 5 minutes and saves it in memory.

the In memory database is implemented with an `Agent` to keep in memory and able to be retrieved at any place in the API.

For Responding to requests, i've used `Plug` and `Cowboy`, as well as `Jason` for JSON encoding,
`Plug` was used to wrap around HTTP requests and a raw Socket handler using `Cowboy`.

For making requests i've used `Tesla`, because it's very simple.

It's all supervised by a single supervision tree.

## Installation

To run this project for development you can follow these steps:
  1. `mix deps.get && mix deps.compile`
  2. `iex -S mix`

To run it through Docker with the `dockerfile` in the root of the project:
  1. `docker build . -t hacker_news_api`
  2. `docker run -p 3000:3000 hacker_news_api:latest`

To deploy it to `fly.io`:
  1. run `flyctl launch`