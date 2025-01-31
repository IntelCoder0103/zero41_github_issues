defmodule Zero41RetrieveGithubIssuesWeb.IssueLive.Index do
  use Zero41RetrieveGithubIssuesWeb, :live_view

  alias Zero41RetrieveGithubIssues.Issues
  alias Zero41RetrieveGithubIssues.Issues.Issue

  @impl true
  def mount(params, _session, socket) do
    page = params["page"] || 1
    per_page = params["per_page"] || 10
    {issues, links} =  Issues.list_issues(%{"page" => page, "per_page" => per_page})
    {:ok, stream(socket, :issues, issues)
      |> assign(:links, links)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Issue")
    |> assign(:issue, Issues.get_issue!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Issue")
    |> assign(:issue, %Issue{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Issues")
    |> assign(:issue, nil)
  end

  @impl true
  def handle_info({Zero41RetrieveGithubIssuesWeb.IssueLive.FormComponent, {:saved, issue}}, socket) do
    {:noreply, stream_insert(socket, :issues, issue)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    issue = Issues.get_issue!(id)
    {:ok, _} = Issues.delete_issue(issue)

    {:noreply, stream_delete(socket, :issues, issue)}
  end
end
