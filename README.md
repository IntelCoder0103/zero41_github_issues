# Zero41 GitHub Issues Viewer

## Overview
This project is an **Elixir Phoenix LiveView** application that allows a logged-in GitHub user to view a list of open issues assigned to them. The app fetches issues from GitHub's API using a personal access token provided via a `.env.local` file.

## Features
- **List all open issues** assigned to the logged-in GitHub user.
- **Filter out closed issues** so only open issues appear.
- **View issue details**, including issue number, title, creation date, and body.
- **Navigate back to the issues list** from the details page.

## Prerequisites
To run this project, ensure you have the following installed:

- **Elixir** (>= 1.14)
- **Phoenix Framework** (>= 1.7)
- **GitHub Personal Access Token** (for API authentication)

## Setup Instructions

1. **Clone the repository:**
   ```sh
   git clone https://github.com/IntelCoder0103/zero41_github_issues.git
   cd zero41_github_issues
   ```

2. **Set up environment variables:**
   - Create a `.env.local` file in the project root.
   - Add your **GitHub Personal Access Token**:
     ```sh
     GITHUB_PERSONAL_TOKEN=your_github_token_here
     ```

3. **Install dependencies:**
   ```sh
   mix deps.get
   ```

4. **Start the Phoenix server:**
   ```sh
   mix phx.server
   ```
   The application will be available at `http://localhost:4000`.

## Usage
- Open `http://localhost:4000` in your browser.
- Log in with your GitHub token.
- View the list of open issues assigned to you.
- Click on an issue to view its details.
- Use the **Back to Issues** link to return to the list.

## API Integration
This application interacts with GitHub's API:
- **Fetching Issues**: Uses `GET https://api.github.com/issues` with authentication.
- **Authentication**: Requires a **GitHub Personal Access Token** in the `Authorization` header.

## Testing
Create a `.env.test` file in the project root as follows.
```sh
GITHUB_PERSONAL_TOKEN=
```

Run the test suite with:
```sh
mix test
```

## Notes
- Ensure `.env.local` is **not** committed to version control.
- If you face authentication issues, check your GitHub token permissions.
