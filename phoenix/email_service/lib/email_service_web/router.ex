defmodule EmailServiceWeb.Router do
  use EmailServiceWeb, :router
  use Plug.ErrorHandler

  def handle_errors(%Plug.Conn{} = conn, %{kind: kind, reason: reason, stack: stack}) do
    response = %{reason: reason, kind: kind, stack: Exception.format_stacktrace(stack)}
    send_resp(conn, conn.status, Poison.encode!(response))
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EmailServiceWeb do
    pipe_through :api
    post "/send-email", EmailController, :send_email
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
      live_dashboard "/dashboard", metrics: EmailServiceWeb.Telemetry
    end
  end
end
