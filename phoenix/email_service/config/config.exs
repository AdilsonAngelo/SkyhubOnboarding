# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# config :email_service,
#   ecto_repos: [EmailService.Repo]

# Configures the endpoint
config :email_service, EmailServiceWeb.Endpoint,
  url: [host: "0.0.0.0"],
  secret_key_base: "WBUkY9D9OLz28zXE+KiVxUKdnZLXDHGnS+BAUoP5HL2Xm90vTw4+JPSqfpVNtbXe",
  render_errors: [view: EmailServiceWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: EmailService.PubSub,
  live_view: [signing_salt: "3xoHkDNM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
