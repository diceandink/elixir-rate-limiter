defmodule RatelimitWeb.Router do
  use RatelimitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RatelimitWeb do
    pipe_through :api
    get "/", LimiterController, :index
    post "/check", LimiterController, :check
  end
end
