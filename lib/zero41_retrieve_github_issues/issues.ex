defmodule Zero41RetrieveGithubIssues.Issues do
  @moduledoc """
  The Issues context.
  """

  import Ecto.Query, warn: false
  alias Zero41RetrieveGithubIssues.Repo

  alias Zero41RetrieveGithubIssues.Issues.Issue
  alias Zero41RetrieveGithubIssues.GithubClient

  @doc """
  Returns the list of issues.

  ## Examples

      iex> list_issues()
      [%Issue{}, ...]

  """
  def list_issues(%{"page" => page, "per_page" => per_page} = params) do
    {:ok, body, links} = GithubClient.list_issues(params)
    IO.inspect(links)

    {
      body
        |> Enum.map(fn issue -> map_issue(issue) end),
      links
    }
  end

  @doc """
  Gets a single issue.

  Raises `Ecto.NoResultsError` if the Issue does not exist.

  ## Examples

      iex> get_issue!(123)
      %Issue{}

      iex> get_issue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_issue!(%{"owner" => owner, "number" => number, "repo" => repo} = param) do
    {:ok, body} = GithubClient.get_issue(param)
    body
    |> map_issue
    |> Map.merge(%{:owner => owner, :number => number, :repo => repo})
  end

  @doc """
  Creates a issue.

  ## Examples

      iex> create_issue(%{field: value})
      {:ok, %Issue{}}

      iex> create_issue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_issue(attrs \\ %{}) do
    # TBD
    # %Issue{}
    # |> Issue.changeset(attrs)
    # |> Repo.insert()
  end

  @doc """
  Updates a issue.

  ## Examples

      iex> update_issue(issue, %{field: new_value})
      {:ok, %Issue{}}

      iex> update_issue(issue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_issue(%Issue{} = issue, attrs) do
    # TBD
    # issue
    # |> Issue.changeset(attrs)
    # |> Repo.update()
  end

  @doc """
  Deletes a issue.

  ## Examples

      iex> delete_issue(issue)
      {:ok, %Issue{}}

      iex> delete_issue(issue)
      {:error, %Ecto.Changeset{}}

  """
  def delete_issue(%Issue{} = issue) do
    # TBD
    # Repo.delete(issue)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking issue changes.

  ## Examples

      iex> change_issue(issue)
      %Ecto.Changeset{data: %Issue{}}

  """
  def change_issue(%Issue{} = issue, attrs \\ %{}) do
    Issue.changeset(issue, attrs)
  end

  def map_issue(issue) do
     %Issue{
        id: issue["id"],
        number: issue["number"],
        title: issue["title"],
        created_at: issue["created_at"],
        body: issue["body"],
        repo: issue["repository"]["name"],
        owner: issue["repository"]["owner"]["login"]
      }
  end
end

defmodule Zero41RetrieveGithubIssues.IssuesBehavior do
  @callback list_issues(map()) :: {list(), map()}
  @callback get_issue!(integer()) :: map()
  @callback delete_issue(map()) :: {:ok, any()} | {:error, any()}
end
