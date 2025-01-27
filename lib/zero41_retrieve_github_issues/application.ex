defmodule Zero41RetrieveGithubIssues.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Zero41RetrieveGithubIssuesWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:zero41_retrieve_github_issues, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Zero41RetrieveGithubIssues.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Zero41RetrieveGithubIssues.Finch},
      # Start a worker by calling: Zero41RetrieveGithubIssues.Worker.start_link(arg)
      # {Zero41RetrieveGithubIssues.Worker, arg},
      # Start to serve requests, typically the last entry
      Zero41RetrieveGithubIssuesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Zero41RetrieveGithubIssues.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Zero41RetrieveGithubIssuesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
