
defmodule SebastianWeb.Router do
  import Phoenix.LiveDashboard.Router
  use SebastianWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    if System.get_env("HTTP_BASIC_AUTH_USERNAME") || System.get_env("HTTP_BASIC_AUTH_PASSWORD") do
      plug BasicAuth, use_config: {:sebastian_auth, :basic_auth}
    end
  end

  scope "/api", SebastianWeb do
    pipe_through :api
  end

  scope "/", SebastianWeb do
    pipe_through [:protected]
    live_dashboard "/dashboard", metrics: SebastianWeb.Telemetry

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
