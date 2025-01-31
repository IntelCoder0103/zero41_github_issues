defmodule Zero41RetrieveGithubIssuesWeb.Router do
  use Zero41RetrieveGithubIssuesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Zero41RetrieveGithubIssuesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Zero41RetrieveGithubIssuesWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/issues", IssueLive.Index, :index
    live "/issues/new", IssueLive.Index, :new
    live "/issues/:id/edit", IssueLive.Index, :edit

    live "/issues/:owner/:repo/:number", IssueLive.Show, :show
    live "/issues/:owner/:repo/:number/show/edit", IssueLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", Zero41RetrieveGithubIssuesWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:zero41_retrieve_github_issues, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Zero41RetrieveGithubIssuesWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
