use Mix.Config

# Configure your database
config :phx_project, PhxProject.Repo,
  database: "phx_project_dev",
  hostname: "mongo",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :exredis,
  host: "redis",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity


config :tirexs, :uri, "http://elasticsearch:9200"


config :sentry,
  dsn: "https://dcc96cd98c0744ba80fe25cb0c23918e@o568167.ingest.sentry.io/5712966",
  environment_name: :dev,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "development"
  },
  included_environments: [:dev]

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :phx_project, PhxProjectWeb.Endpoint,
  http: [port: 4000],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]


config :phx_project,
  email_service_address: [host: "emailservice", port: 5000]

config :task_bunny, hosts: [
  default: [connect_options: "amqp://rabbitmq?heartbeat=30"]
]

config :task_bunny, queue: [
  namespace: "phx_project_dev.",
  queues: [[name: "products", jobs: :default]]
]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
