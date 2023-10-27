defmodule PaginateInfiniteScrollPatch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PaginateInfiniteScrollPatchWeb.Telemetry,
      # Start the Ecto repository
      PaginateInfiniteScrollPatch.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PaginateInfiniteScrollPatch.PubSub},
      # Start Finch
      {Finch, name: PaginateInfiniteScrollPatch.Finch},
      # Start the Endpoint (http/https)
      PaginateInfiniteScrollPatchWeb.Endpoint
      # Start a worker by calling: PaginateInfiniteScrollPatch.Worker.start_link(arg)
      # {PaginateInfiniteScrollPatch.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PaginateInfiniteScrollPatch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PaginateInfiniteScrollPatchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
