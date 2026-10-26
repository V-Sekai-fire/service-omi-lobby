# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Attach OpenTelemetry instrumentation to Phoenix + Ecto. Span exporting
    # is configured via :opentelemetry / :opentelemetry_exporter in
    # config/prod.exs.
    OpentelemetryPhoenix.setup(adapter: :bandit)
    OpentelemetryEcto.setup([:uro, :repo])

    children =
      if System.get_env("MINIMAL_START") == "true",
        do: [],
        else: [
          Uro.Repository.Repo,
          Uro.Transport.Web.Endpoint,
          lobby_poller(),
          Uro.Service.Pow.DetsCache,
          {Phoenix.PubSub, [name: Uro.PubSub, adapter: Phoenix.PubSub.PG2]},
          ExMarcel.TableWrapper,

          # ExMarcel
          {Task, fn -> Uro.Entities.Support.Validation.init_extra_extensions() end}
        ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Uro.Supervisor]
    Supervisor.start_link(Enum.reject(children, &is_nil/1), opts)
  end

  defp lobby_poller do
    if Application.get_env(:uro, :lobby_poller, true), do: Uro.Transport.Poller
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Uro.Transport.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
