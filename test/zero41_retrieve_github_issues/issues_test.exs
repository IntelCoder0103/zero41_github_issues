defmodule Zero41RetrieveGithubIssues.IssuesTest do
  use Zero41RetrieveGithubIssues.DataCase

  alias Zero41RetrieveGithubIssues.Issues

  describe "issues" do
    alias Zero41RetrieveGithubIssues.Issues.Issue

    import Zero41RetrieveGithubIssues.IssuesFixtures

    @invalid_attrs %{title: nil, number: nil, body: nil, created_at: nil}

    test "list_issues/0 returns all issues" do
      issue = issue_fixture()
      assert Issues.list_issues() == [issue]
    end

    test "get_issue!/1 returns the issue with given id" do
      issue = issue_fixture()
      assert Issues.get_issue!(issue.id) == issue
    end

    test "create_issue/1 with valid data creates a issue" do
      valid_attrs = %{title: "some title", number: 42, body: "some body", created_at: ~U[2025-01-26 14:19:00Z]}

      assert {:ok, %Issue{} = issue} = Issues.create_issue(valid_attrs)
      assert issue.title == "some title"
      assert issue.number == 42
      assert issue.body == "some body"
      assert issue.created_at == ~U[2025-01-26 14:19:00Z]
    end

    test "create_issue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Issues.create_issue(@invalid_attrs)
    end

    test "update_issue/2 with valid data updates the issue" do
      issue = issue_fixture()
      update_attrs = %{title: "some updated title", number: 43, body: "some updated body", created_at: ~U[2025-01-27 14:19:00Z]}

      assert {:ok, %Issue{} = issue} = Issues.update_issue(issue, update_attrs)
      assert issue.title == "some updated title"
      assert issue.number == 43
      assert issue.body == "some updated body"
      assert issue.created_at == ~U[2025-01-27 14:19:00Z]
    end

    test "update_issue/2 with invalid data returns error changeset" do
      issue = issue_fixture()
      assert {:error, %Ecto.Changeset{}} = Issues.update_issue(issue, @invalid_attrs)
      assert issue == Issues.get_issue!(issue.id)
    end

    test "delete_issue/1 deletes the issue" do
      issue = issue_fixture()
      assert {:ok, %Issue{}} = Issues.delete_issue(issue)
      assert_raise Ecto.NoResultsError, fn -> Issues.get_issue!(issue.id) end
    end

    test "change_issue/1 returns a issue changeset" do
      issue = issue_fixture()
      assert %Ecto.Changeset{} = Issues.change_issue(issue)
    end
  end
end
