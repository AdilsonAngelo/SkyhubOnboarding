defmodule PhxProject.MixProject do
  use Mix.Project

  def project do
    [
      app: :phx_project,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PhxProject.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :mongodb_ecto,
        :ecto,
        :tirexs,
        :task_bunny,
        :httpoison
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto, "~> 2.1.6", override: true},
      {:mongodb_ecto, "~> 0.2.1"},
      {:phoenix_live_dashboard, "~> 0.2.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:exredis, "~> 0.3.0"},
      {:poison, "~> 3.0"},
      {:tirexs, "~> 0.8"},
      {:csv, "~> 2.4"},
      {:task_bunny, "~> 0.3.4"},
      {:httpoison, "~> 1.7"},
      {:sentry, "~> 8.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["test"]
    ]
  end
end
