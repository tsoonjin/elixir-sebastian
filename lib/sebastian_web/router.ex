
defmodule SebastianWeb.Router do
  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth
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

  pipeline :admins_only do
    # plug :basic_auth, Application.fetch_env!(:sebastian, SebastianWeb.Endpoint)[:basic_auth]
    plug :basic_auth, username: "mrgin", password: "SecretKeeper00"
  end

  pipeline :protected do
    if System.get_env("HTTP_BASIC_AUTH_USERNAME") || System.get_env("HTTP_BASIC_AUTH_PASSWORD") do
      plug :basic_auth, Application.fetch_env!(:sebastian, :basic_auth)
    end
  end

  scope "/api", SebastianWeb do
    pipe_through :api
  end

  if Mix.env() in [:prod] do
    scope "/", SebastianWeb do
      pipe_through [:browser, :admins_only]
      live_dashboard "/dashboard"
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    Logger.info Application.fetch_env!(:sebastian, SebastianWeb.Endpoint)[:basic_auth]
    scope "/" do
      pipe_through [:browser, :admins_only]
      live_dashboard "/dashboard"
    end
  end
end
