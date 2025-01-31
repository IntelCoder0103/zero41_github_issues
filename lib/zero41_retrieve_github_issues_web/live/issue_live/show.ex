defmodule Zero41RetrieveGithubIssuesWeb.IssueLive.Show do
  use Zero41RetrieveGithubIssuesWeb, :live_view

  alias Zero41RetrieveGithubIssues.Cldr
  alias Zero41RetrieveGithubIssues.Issues

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    issue = Map.merge(Issues.get_issue!(params), params)
    IO.inspect(issue)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:issue, issue)}
  end

  defp page_title(:show), do: "Show Issue"
  defp page_title(:edit), do: "Edit Issue"

  def format_date(date) do
    case DateTime.from_iso8601(date) do
      {:ok, datetime, _offset} ->
        case Cldr.DateTime.to_string(datetime) do
          {:ok, str} -> str
          {:error, reason} -> IO.inspect(reason, label: "Failed to format date")
        end
      {:error, reason} ->
        IO.inspect(reason, label: "Failed parsing date")
    end
  end
end
