defmodule Zero41RetrieveGithubIssuesWeb.IssueLive.FormComponent do
  use Zero41RetrieveGithubIssuesWeb, :live_component

  alias Zero41RetrieveGithubIssues.Issues

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage the issue from Github.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="issue-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:number]} type="number" label="Number" disabled/>
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="textarea" label="Body" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Issue</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{issue: issue} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Issues.change_issue(issue))
     end)}
  end

  @impl true
  def handle_event("validate", %{"issue" => issue_params}, socket) do
    changeset = Issues.change_issue(socket.assigns.issue, issue_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"issue" => issue_params}, socket) do
    save_issue(socket, socket.assigns.action, issue_params)
  end

  defp save_issue(socket, :edit, issue_params) do
    case Issues.update_issue(socket.assigns.issue, issue_params) do
      {:ok, issue} ->
        notify_parent({:saved, issue})

        {:noreply,
         socket
         |> put_flash(:info, "Issue updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_issue(socket, :new, issue_params) do
    case Issues.create_issue(issue_params) do
      {:ok, issue} ->
        notify_parent({:saved, issue})

        {:noreply,
         socket
         |> put_flash(:info, "Issue created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
