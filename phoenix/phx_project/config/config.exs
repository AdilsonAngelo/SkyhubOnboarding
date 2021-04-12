# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phx_project,
  ecto_repos: [PhxProject.Repo]

# Configures the endpoint
config :phx_project, PhxProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oBnFK7bBRj6FKxzu353ADL7x1yvNJbnM8cP/Ygf00EyHBKJHIxCf5kpCW1dXJUid",
  render_errors: [view: PhxProjectWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PhxProject.PubSub,
  live_view: [signing_salt: "C+hvFcSj"]

# Configures Elixir's Logger
config :logger,
  backends: [:console, Sentry.LoggerBackend],
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
