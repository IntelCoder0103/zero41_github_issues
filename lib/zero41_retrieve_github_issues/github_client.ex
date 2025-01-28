defmodule Zero41RetrieveGithubIssues.GithubClient do
  use Tesla

  @base_url "https://api.github.com"

  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON

  def list_issues(%{"page" => page, "per_page" => per_page} = params) do
    get(
      "/issues?state=open&per_page=#{per_page}&page=#{page}",
      headers: headers()
      )
    |> handle_paginated_response()
  end

  def get_issue(%{"owner" => owner, "number" => number, "repo" => repo}) do
    get(
      "/repos/#{owner}/#{repo}/issues/#{number}",
      headers: headers()
    )
    |> handle_response()
  end

  def headers do
    token = Application.get_env(:zero41_retrieve_github_issues, :github_personal_token)
    [
      {"Authorization", "Bearer #{token}"},
      {"Accept", "application/vnd.github+json"},
      {"X-GitHub-Api-Version", "2022-11-28"},
      {"User-Agent", "github-issues"}
    ]
  end

  defp handle_paginated_response({:ok, %{status: 200, body: body, headers: headers}}) do
    links = parse_pagination_links(headers)
    {:ok, body, links}
  end

  defp handle_paginated_response(other) do
    handle_response(other)
  end
  defp handle_response({:ok, %{status: 200, body: body}}), do: {:ok, body}
  defp handle_response({:ok, %{status: status, body: body}}), do: {:error, {status, body}}
  defp handle_response({:error, reason}), do: {:error, reason}

  defp parse_pagination_links(headers) do
    headers
    |> Enum.find(fn {key, _value} -> key == "link" end)
    |> case do
      nil -> %{} # No pagination links
      {"link", link_header} -> extract_links(link_header)
    end
  end

  defp extract_links(link_header) do
    link_header
    |> String.split(",") # Split multiple links
    |> Enum.map(fn link ->
      # Extract URL and rel type
      [_, url, rel] = Regex.run(~r/<([^>]+)>;\s*rel="([^"]+)"/, link)
      parsed_url = URI.parse(url)

      {rel, parsed_url.query}
    end)
    |> Enum.into(%{}) # Convert to map
  end
end
