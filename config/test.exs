import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zero41_retrieve_github_issues, Zero41RetrieveGithubIssuesWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "klfjz7dwh0/DljWSFwbBHgoA5OXRNgGcwrjetCr7Yn8cP2UA/rwO0d72TIIC58ya",
  server: false

# In test we don't send emails
config :zero41_retrieve_github_issues, Zero41RetrieveGithubIssues.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :tesla, adapter: Tesla.Mock
