use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phx_project, PhxProject.Repo,
  database: "phx_project_test",
  hostname: "0.0.0.0",
  show_sensitive_data_on_connection_error: true,
  pool_size: 1


config :exredis,
  host: "0.0.0.0",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity

config :tirexs, :uri, "http://0.0.0.0:9200"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phx_project, PhxProjectWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
