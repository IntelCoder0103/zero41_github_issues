defmodule Zero41RetrieveGithubIssuesWeb.IssueLiveTest do
  use Zero41RetrieveGithubIssuesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Zero41RetrieveGithubIssues.IssuesFixtures

  @create_attrs %{title: "some title", number: 42, body: "some body", created_at: "2025-01-26T14:19:00Z"}
  @update_attrs %{title: "some updated title", number: 43, body: "some updated body", created_at: "2025-01-27T14:19:00Z"}
  @invalid_attrs %{title: nil, number: nil, body: nil, created_at: nil}

  defp create_issue(_) do
    issue = issue_fixture()
    %{issue: issue}
  end

  describe "Index" do
    setup [:create_issue]

    test "lists all issues", %{conn: conn, issue: issue} do
      {:ok, _index_live, html} = live(conn, ~p"/issues")

      assert html =~ "Listing Issues"
      assert html =~ issue.title
    end

    test "saves new issue", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/issues")

      assert index_live |> element("a", "New Issue") |> render_click() =~
               "New Issue"

      assert_patch(index_live, ~p"/issues/new")

      assert index_live
             |> form("#issue-form", issue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#issue-form", issue: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/issues")

      html = render(index_live)
      assert html =~ "Issue created successfully"
      assert html =~ "some title"
    end

    test "updates issue in listing", %{conn: conn, issue: issue} do
      {:ok, index_live, _html} = live(conn, ~p"/issues")

      assert index_live |> element("#issues-#{issue.id} a", "Edit") |> render_click() =~
               "Edit Issue"

      assert_patch(index_live, ~p"/issues/#{issue}/edit")

      assert index_live
             |> form("#issue-form", issue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#issue-form", issue: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/issues")

      html = render(index_live)
      assert html =~ "Issue updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes issue in listing", %{conn: conn, issue: issue} do
      {:ok, index_live, _html} = live(conn, ~p"/issues")

      assert index_live |> element("#issues-#{issue.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#issues-#{issue.id}")
    end
  end

  describe "Show" do
    setup [:create_issue]

    test "displays issue", %{conn: conn, issue: issue} do
      {:ok, _show_live, html} = live(conn, ~p"/issues/#{issue}")

      assert html =~ "Show Issue"
      assert html =~ issue.title
    end

    test "updates issue within modal", %{conn: conn, issue: issue} do
      {:ok, show_live, _html} = live(conn, ~p"/issues/#{issue}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Issue"

      assert_patch(show_live, ~p"/issues/#{issue}/show/edit")

      assert show_live
             |> form("#issue-form", issue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#issue-form", issue: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/issues/#{issue}")

      html = render(show_live)
      assert html =~ "Issue updated successfully"
      assert html =~ "some updated title"
    end
  end
end
