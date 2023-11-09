defmodule Truckdb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TruckdbWeb.Telemetry,
      Truckdb.Repo,
      {DNSCluster, query: Application.get_env(:truckdb, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Truckdb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Truckdb.Finch},
      # Start a worker by calling: Truckdb.Worker.start_link(arg)
      # {Truckdb.Worker, arg},
      # Start to serve requests, typically the last entry
      TruckdbWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Truckdb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TruckdbWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
