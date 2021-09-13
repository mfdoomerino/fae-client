defmodule FaeClientv2Web.Router do
  use FaeClientv2Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FaeClientv2Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug FaeClientv2Web.Plugs.AuthenticatedPipeline
  end

  scope "/", FaeClientv2Web do
    pipe_through :browser

    post "/sign_in", SessionController, :sign_in
    resources "/accounts", SessionController, only: [:index]
  end

  scope "/dashboard", FaeClientv2Web do
    pipe_through [:browser, :authenticated]

    resources "/", DashboardController, only: [:index]
  end
end
