# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.MixProject do
  use Mix.Project

  def project do
    [
      app: :uro,
      version: "0.1.0",
      elixir: ">= 1.16.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer()
    ]
  end

  # `mix dialyzer` (dialyxir). PLTs are cached under `priv/plts` (not
  # `_build`) so a `mix clean`/fresh `_build` doesn't force a full PLT
  # rebuild -- that's the slow part (core Erlang/Elixir PLT), not
  # incremental analysis of this app's own modules.
  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      plt_add_apps: [:mix, :ex_unit],
      ignore_warnings: ".dialyzer_ignore.exs"
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Uro.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :mnesia,
        :scrivener_ecto,
        :httpoison,
        :opentelemetry_exporter,
        :opentelemetry
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
    common_deps()
  end

  defp common_deps do
    [
      {:phoenix, "~> 1.7"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.4"},
      # Pow compiles its templates with Phoenix.Component.
      {:phoenix_live_view, "~> 0.20.3"},
      {:phoenix_view, "~> 2.0"},
      {:ecto_sql, "~> 3.13"},
      {:ecto_sqlite3, "~> 0.17"},
      {:phoenix_html, "~> 3.3"},
      {:cors_plug, "~> 3.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:gettext, "~> 0.18"},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:joken, "~> 2.6"},
      {:bandit, "~> 1.0"},
      {:bcrypt_elixir, "~> 2.3"},
      {:nimble_totp, "~> 1.0"},
      {:wax_, "~> 0.7.0"},
      {:pow, "~> 1.0"},
      {:pow_assent, "~> 0.4.18"},
      {:ssl_verify_fun, "~> 1.1.6"},
      {:open_api_spex, "~> 3.21"},
      {:remote_ip, "~> 1.0"},
      {:waffle, "~> 1.1"},
      {:waffle_ecto, "~> 0.0.10"},
      # Waffle.Storage.S3 (UPLOAD_STORAGE=s3) calls these; aria_storage used to bring them in.
      {:ex_aws, "~> 2.6"},
      {:ex_aws_s3, "~> 2.5"},
      {:ecto_commons, "~> 0.3.4"},
      {:swoosh, "~> 1.3"},
      {:scrivener_ecto, "~> 3.1"},
      {:ex_marcel, "~> 0.1.0"},

      # OpenTelemetry — ships spans + logs to multiplayer-fabric-observability
      {:opentelemetry, "~> 1.6"},
      {:opentelemetry_api, "~> 1.4"},
      {:opentelemetry_exporter, "~> 1.9"},
      {:opentelemetry_phoenix, "~> 2.0"},
      {:opentelemetry_ecto, "~> 1.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "uro.apigen": [
        "openapi.spec.json --spec Uro.Contract.OpenAPI.Specification --pretty --vendor-extensions=false ./frontend/src/__generated/openapi.json"
      ],

      # Not required, fixes warning https://github.com/chaskiq/ex-marcel/pull/2
      "patch.exmarcel": fn _args ->
        path = "deps/ex_marcel/lib/magic.ex"

        patched =
          String.replace(
            File.read!(path),
            "ext |> String.slice(1..-1)",
            "ext |> String.slice(1..-1//1)"
          )

        File.write!(path, patched)
        IO.puts("Module 'ex_marcel' patched successfully!")
      end,
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
