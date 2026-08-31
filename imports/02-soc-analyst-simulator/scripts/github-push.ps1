param(
  [string]$RepoName = "02-soc-analyst-simulator",
  [string]$GitHubUser = "YOUR-GITHUB-USERNAME"
)

$ErrorActionPreference = "Stop"

git init
git add .
git commit -m "Initial commit: SOC analyst simulator"
git branch -M main
git remote add origin "https://github.com/$GitHubUser/$RepoName.git"
git push -u origin main
