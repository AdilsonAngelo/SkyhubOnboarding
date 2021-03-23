defmodule PhxProjectWeb.Router do
  use PhxProjectWeb, :router
  use Plug.ErrorHandler

  alias PhxProject.Utils.ESHelper

  def handle_errors(%Plug.Conn{} = conn, %{kind: _kind, reason: reason, stack: stack}) do
    response = %{reason: reason.message, stack: Exception.format_stacktrace(stack)}
    conn
    |> register_before_send(&error_before_send/1)
    |> send_resp(conn.status, Poison.encode!(response))
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PhxProjectWeb.Plugs.ProductsPlug
  end

  scope "/api", PhxProjectWeb do
    pipe_through :api
    resources "/products", ProductController
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: PhxProjectWeb.Telemetry
    end
  end

  def error_before_send(conn), do: ESHelper.to_es_before_send(conn, :errors)
end
