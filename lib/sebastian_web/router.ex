
defmodule SebastianWeb.Router do
  import Phoenix.LiveDashboard.Router
  require Logger
  use SebastianWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    Logger.info "Protected"
    if System.get_env("HTTP_BASIC_AUTH_USERNAME") || System.get_env("HTTP_BASIC_AUTH_PASSWORD") do
      Logger.info "Basic Auth triggered"
      plug BasicAuth, use_config: {:sebastian, :basic_auth}
    end
  end

  scope "/api", SebastianWeb do
    pipe_through :api
  end

  scope "/", SebastianWeb do
    pipe_through [:browser, :protected]
    # live_dashboard "/dashboard", metrics: SebastianWeb.Telemetry
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: SebastianWeb.Telemetry
    end
  end
end
