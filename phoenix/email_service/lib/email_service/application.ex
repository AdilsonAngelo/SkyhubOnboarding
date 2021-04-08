defmodule EmailService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # EmailService.Repo,
      # Start the Telemetry supervisor
      EmailServiceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EmailService.PubSub},
      # Start the Endpoint (http/https)
      EmailServiceWeb.Endpoint
      # Start a worker by calling: EmailService.Worker.start_link(arg)
      # {EmailService.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EmailService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EmailServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
