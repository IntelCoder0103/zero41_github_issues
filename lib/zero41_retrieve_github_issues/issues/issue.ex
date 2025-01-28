defmodule Zero41RetrieveGithubIssues.Issues.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "issues" do
    field :title, :string
    field :number, :integer
    field :body, :string
    field :created_at, :utc_datetime
    field :repo, :string
    field :owner, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:number, :title, :created_at, :body, :repo, :owner])
    |> validate_required([:number, :title, :created_at, :body, :repo, :owner])
  end
end
