defmodule Zero41RetrieveGithubIssues.GithubClient do
  use Tesla

  @base_url "https://api.github.com"

  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON

  def list_issues do
    get(
      "/issues?state=open",
      headers: headers()
      )
    |> handle_response()
  end

  def get_issue(%{"owner" => owner, "number" => number, "repo" => repo}) do
    get(
      "/repos/#{owner}/#{repo}/issues/#{number}",
      headers: headers()
    )
    |> handle_response()
  end

  def headers do
    token = Application.get_env(:zero41_retrieve_github_issues, :github_personal_token)
    [
      {"Authorization", "Bearer #{token}"},
      {"Accept", "application/vnd.github+json"},
      {"X-GitHub-Api-Version", "2022-11-28"},
      {"User-Agent", "github-issues"}
    ]
  end

  defp handle_response({:ok, %{status: 200, body: body}}), do: {:ok, body}
  defp handle_response({:ok, %{status: status, body: body}}), do: {:error, {status, body}}
  defp handle_response({:error, reason}), do: {:error, reason}
end
