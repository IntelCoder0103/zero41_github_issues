defmodule Zero41RetrieveGithubIssues.IssuesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zero41RetrieveGithubIssues.Issues` context.
  """

  @doc """
  Generate a issue.
  """
  def issue_fixture(attrs \\ %{}) do
    {:ok, issue} =
      attrs
      |> Enum.into(%{
        body: "some body",
        created_at: ~U[2025-01-26 14:19:00Z],
        number: 42,
        title: "some title"
      })
      |> Zero41RetrieveGithubIssues.Issues.create_issue()

    issue
  end
end
