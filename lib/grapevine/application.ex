defmodule Grapevine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GrapevineWeb.Telemetry,
      # Start the Ecto repository
      Grapevine.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Grapevine.PubSub},
      # Start Finch
      {Finch, name: Grapevine.Finch},
      # Start the Endpoint (http/https)
      GrapevineWeb.Endpoint,
      # Start a worker by calling: Grapevine.Worker.start_link(arg)
      # {Grapevine.Worker, arg}
      Grapevine.Presence,
      Grapevine.MessageServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Grapevine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GrapevineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
