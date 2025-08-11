---
allowed-tools: Bash(git init), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git remote:*), Bash(gh repo create:*), Bash(gh api:*), Read, Write
argument-hint: [--name <repo-name>] [--private | --public] [--description <desc>] [--no-push]
description: Initialize a git repo and connect it to GitHub
---

Initialize a new git repository and create a corresponding GitHub repository.

Parse the arguments: $ARGUMENTS

Extract these parameters:
- Repository name from --name or -n flag (default to current directory name)
- Visibility from --private or --public flag (default: public)
- Description from --description or -d flag
- Whether to push initially (default: yes, unless --no-push is specified)

Steps to execute:

1. Check if git is already initialized, if not run `git init`

2. Create the GitHub repository using:
   `gh repo create "<repo-name>" <visibility-flag> --source=. --remote=origin [--description "<description>"]`

3. If no commits exist yet:
   - Create .gitignore if missing (include: node_modules/, .env, .DS_Store, logs/, .claude/)
   - Create README.md if missing (with repo name and description)
   - Stage files with `git add .gitignore README.md`
   - Create initial commit: `git commit -m "Initial commit"`

4. Unless --no-push was specified:
   - Push to origin: `git push -u origin main` (or master if main fails)
   - Display the GitHub repository URL

Provide clear feedback at each step and handle errors gracefully.