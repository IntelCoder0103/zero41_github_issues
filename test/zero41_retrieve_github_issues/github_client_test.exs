defmodule Zero41RetrieveGithubIssues.GithubClientTest do
  use ExUnit.Case, async: true

  alias Zero41RetrieveGithubIssues.GithubClient
  import Tesla.Mock

  setup do
    # Mock environment variable for authentication token
    Application.put_env(:zero41_retrieve_github_issues, :github_personal_token, "mock_token")

    :ok
  end

  describe "list_issues/1" do
    test "returns a list of issues with pagination links" do
      mock(fn
        %{method: :get, url: "https://api.github.com/issues", query: query_params} ->
          assert query_params["per_page"] == "10"
          assert query_params["page"] == "1"

          {:ok,
           %Tesla.Env{
             status: 200,
             body: [%{"id" => 1, "title" => "Issue 1"}, %{"id" => 2, "title" => "Issue 2"}],
             headers: [{"link", "<https://api.github.com/issues?page=2>; rel=\"next\""}]
           }}
      end)

      params = %{"page" => "1", "per_page" => "10"}
      assert {:ok, issues, links} = GithubClient.list_issues(params)

      assert length(issues) == 2
      assert links["next"] == "page=2"
    end

    test "returns error for failed request" do
      mock(fn _ ->
        {:ok, %Tesla.Env{status: 500, body: "Internal Server Error"}}
      end)

      params = %{"page" => "1", "per_page" => "10"}
      assert {:error, {500, "Internal Server Error"}} = GithubClient.list_issues(params)
    end
  end

  describe "get_issue/1" do
    test "returns issue details for a valid request" do
      mock(fn
        %{method: :get, url: "https://api.github.com/repos/elixir-lang/elixir/issues/123"} ->
          {:ok,
           %Tesla.Env{
             status: 200,
             body: %{"id" => 123, "title" => "Test issue"}
           }}
      end)

      params = %{"owner" => "elixir-lang", "repo" => "elixir", "number" => "123"}
      assert {:ok, issue} = GithubClient.get_issue(params)

      assert issue["id"] == 123
      assert issue["title"] == "Test issue"
    end

    test "returns error for non-existent issue" do
      mock(fn _ ->
        {:ok, %Tesla.Env{status: 404, body: "Not Found"}}
      end)

      params = %{"owner" => "elixir-lang", "repo" => "elixir", "number" => "9999"}
      assert {:error, {404, "Not Found"}} = GithubClient.get_issue(params)
    end
  end

  describe "headers/0" do
    test "includes the correct authentication headers" do
      headers = GithubClient.headers()

      assert {"Authorization", "Bearer mock_token"} in headers
      assert {"Accept", "application/vnd.github+json"} in headers
      assert {"X-GitHub-Api-Version", "2022-11-28"} in headers
      assert {"User-Agent", "github-issues"} in headers
    end
  end
end
