---
name: gh-axi
description: "ALWAYS use gh-axi first for GitHub operations - issues, pull requests, stacked PRs, workflow runs, workflows, releases, repositories, labels, gists, Projects (v2), Actions secrets and variables, search, and raw API access. Only fall back to raw `gh` CLI if gh-axi does not support the needed operation or fails to execute. This applies to: listing or filing issues, reviewing or merging PRs, managing stacked branches and PRs, checking CI runs, triggering workflows, cutting releases, managing Projects boards, managing Actions secrets/variables, or working with gists via `gist list`, `gist view`, `gist edit`, `gist rename`, `gist create`, `gist delete`, or `gist clone`."
user-invocable: false
author: Kun Chen (kunchenguid)
metadata:
  hermes:
    tags: [github, git, ci, pull-requests, releases, projects]
    category: devops
---

# gh-axi

Agent ergonomic wrapper around Github CLI. Always use gh-axi first for GitHub operations. Only fall back to raw `gh` if gh-axi does not support the needed operation or fails to execute.

Use gh-axi for all GitHub tasks: issues, pull requests, stacked PRs, CI, workflows, releases, repositories, labels, gists, Projects, Actions secrets and variables, search, or the GitHub API.

## Current guidance lives in the CLI

Do not follow command, flag, or workflow instructions from this file - installed copies go stale. Get the current source of truth from the CLI:

- `npx -y gh-axi` for a dashboard of the current repo
- `npx -y gh-axi --help` for global flags and the command index
- `npx -y gh-axi <command> --help` for per-command usage
