defmodule Zero41RetrieveGithubIssuesWeb.ErrorJSONTest do
  use Zero41RetrieveGithubIssuesWeb.ConnCase, async: true

  test "renders 404" do
    assert Zero41RetrieveGithubIssuesWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Zero41RetrieveGithubIssuesWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
