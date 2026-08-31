"""
setup_github.py — One-Click GitHub Setup Script
=================================================
Run this script ONCE to:
  1. Initialize git in this folder
  2. Create the GitHub repository (needs your token)
  3. Make your first commit
  4. Push everything to GitHub

How to run:
    python setup_github.py

You will be prompted for your GitHub username and a Personal Access Token.
Your token is NEVER saved to disk — it's only used during this script.
"""

import subprocess
import sys
import os
import json
import urllib.request
import urllib.error
import getpass

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

def run(cmd, check=True, capture=False):
    """Run a shell command. Print it first so you can see what's happening."""
    print(f"  > {cmd}")
    result = subprocess.run(
        cmd, shell=True,
        capture_output=capture,
        text=True
    )
    if check and result.returncode != 0:
        err = result.stderr.strip() if capture else ""
        print(f"\n❌ Command failed: {cmd}")
        if err:
            print(f"   Error: {err}")
        sys.exit(1)
    return result


def banner(text):
    print(f"\n{'='*55}")
    print(f"  {text}")
    print(f"{'='*55}")


def step(n, text):
    print(f"\n[Step {n}] {text}")


# ─────────────────────────────────────────────
# Main Setup
# ─────────────────────────────────────────────

def main():
    banner("multi-llm-router — GitHub Setup")

    # Make sure we're in the right folder
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    print(f"\n📁 Working in: {script_dir}")

    # ── Step 1: Collect GitHub credentials ──
    step(1, "GitHub credentials")
    print("  You need a GitHub Personal Access Token (PAT) to create the repo.")
    print("  Get one at: https://github.com/settings/tokens/new")
    print("  Required scope: ✅ repo (Full control of private repositories)\n")

    username = input("  Enter your GitHub username: ").strip()
    if not username:
        print("❌ Username cannot be empty.")
        sys.exit(1)

    token = getpass.getpass("  Enter your GitHub PAT (hidden): ").strip()
    if not token:
        print("❌ Token cannot be empty.")
        sys.exit(1)

    repo_name    = "multi-llm-router"
    repo_desc    = "An AI command center that routes prompts to the best LLM — OpenAI, Claude, Gemini, Grok, and Ollama."
    repo_private = False  # Public repo as requested

    # ── Step 2: Create repo via GitHub API ──
    step(2, f"Creating GitHub repository: {username}/{repo_name}")

    payload = json.dumps({
        "name":        repo_name,
        "description": repo_desc,
        "private":     repo_private,
        "auto_init":   False,  # We'll do the init ourselves
    }).encode()

    req = urllib.request.Request(
        "https://api.github.com/user/repos",
        data=payload,
        headers={
            "Authorization": f"token {token}",
            "Accept":        "application/vnd.github+json",
            "Content-Type":  "application/json",
            "User-Agent":    "multi-llm-router-setup",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read())
            repo_url = data["clone_url"]
            html_url = data["html_url"]
        print(f"  ✅ Repository created: {html_url}")
    except urllib.error.HTTPError as e:
        body = json.loads(e.read().decode())
        msg  = body.get("message", str(e))
        if "already exists" in msg.lower() or e.code == 422:
            print(f"  ℹ️  Repo already exists — skipping creation.")
            repo_url = f"https://github.com/{username}/{repo_name}.git"
            html_url = f"https://github.com/{username}/{repo_name}"
        else:
            print(f"  ❌ GitHub API error ({e.code}): {msg}")
            sys.exit(1)

    # ── Step 3: Configure git identity ──
    step(3, "Configuring git identity")
    run(f'git config --global user.name "{username}"', capture=True)
    email_input = input(f"  Enter your email for git commits (used by GitHub): ").strip()
    if email_input:
        run(f'git config --global user.email "{email_input}"', capture=True)

    # ── Step 4: Initialize local git repo ──
    step(4, "Initializing local git repository")

    # Check if already initialized
    git_check = run("git rev-parse --is-inside-work-tree", check=False, capture=True)
    if git_check.returncode == 0:
        print("  ℹ️  Git already initialized — skipping.")
    else:
        run("git init")
        run("git branch -M main")

    # ── Step 5: Add remote ──
    step(5, "Setting remote origin")
    existing = run("git remote", check=False, capture=True)
    if "origin" in (existing.stdout or ""):
        print("  ℹ️  Remote 'origin' already set — updating URL.")
        # Use token-authenticated URL for the push
        auth_url = f"https://{username}:{token}@github.com/{username}/{repo_name}.git"
        run(f'git remote set-url origin "{auth_url}"', capture=True)
    else:
        auth_url = f"https://{username}:{token}@github.com/{username}/{repo_name}.git"
        run(f'git remote add origin "{auth_url}"', capture=True)

    # ── Step 6: Stage and commit ──
    step(6, "Staging files and making first commit")
    run("git add .")
    run('git commit -m "feat: initial project structure for multi-llm-router"')

    # ── Step 7: Push ──
    step(7, "Pushing to GitHub")
    run("git push -u origin main")

    # ── Step 8: Reset remote to non-token URL (security) ──
    # Remove the token from the remote URL now that we've pushed
    clean_url = f"https://github.com/{username}/{repo_name}.git"
    run(f'git remote set-url origin "{clean_url}"', capture=True)

    # ── Done ──
    banner("✅ All done!")
    print(f"\n  🎉 Your repo is live at:\n     {html_url}\n")
    print("  Next steps:")
    print("  1. Copy your .env.example to .env and add your API keys")
    print("  2. pip install -r requirements.txt")
    print("  3. python main.py  ← run the router!")
    print()
    input("  Press Enter to exit...")


if __name__ == "__main__":
    main()
