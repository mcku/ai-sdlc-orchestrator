# Well-known tools

Catalog of tools (MCPs, CLIs, library SDKs) the agent should reach for, organized by purpose. Prefer authoritative tool output over training-data inference.

The list is intentionally broader than what any one project will install — pick what your project needs, install it, and the agent will use it.

---

## Code search & navigation

| Tool | When to reach for it |
|---|---|
| `Grep` / ripgrep / Glob (built-in) | Default for find-by-content and find-by-name. Always available. |
| LSP MCP / Code-intel MCP | When you need symbol-level info: definitions, references, call hierarchy. Beats grep for cross-file impact analysis. |
| Sourcegraph MCP (or similar) | Repository-wide search across multiple repos in a monorepo or org. |

## Library / API documentation

| Tool | When to reach for it |
|---|---|
| **Context7 MCP** | Anytime the work touches a library, framework, SDK, API, or CLI tool. Resolves library ID and fetches current docs. Use even for libraries you "know" — training data drifts. |
| Web fetch / search | Only when Context7 doesn't cover the source (e.g., a specific blog post the user linked). |

## Browser & UI testing

| Tool | When to reach for it |
|---|---|
| Playwright MCP / Browser MCP | Phase 05 UI testing; reproducing a UI bug; verifying a frontend change end-to-end. |
| Local dev server + curl | Quick API smoke tests when full browser automation is overkill. |

## Database / data

| Tool | When to reach for it |
|---|---|
| Project DB CLI (psql, mysql, sqlite3) | Read-only inspection during analysis. Never run mutations without explicit user approval. |
| Database MCP (if configured) | Schema inspection, query construction, plan analysis. Same read-only default. |

## Secrets & credentials

| Tool | When to reach for it |
|---|---|
| Project secret manager CLI (`doppler`, `op`, `aws secretsmanager`, etc.) | When code needs a credential and you can fetch it without copying it into the conversation. |

Never paste secrets into chat, files, or commits. If a tool can't fetch a secret without surfacing it, ask the user to provide it via env var.

## Version control & code review

| Tool | When to reach for it |
|---|---|
| `git` CLI | Default for status, diff, log, blame, branch operations. Always confirm before destructive ops (`reset --hard`, `push --force`, branch deletion). |
| GitHub/GitLab CLI (`gh`, `glab`) | PR creation, comment review, CI status. **Only when explicitly requested by the user.** |
| GitHub MCP | Same use cases as `gh`, when MCP is configured. |

## Issue tracking

| Tool | When to reach for it |
|---|---|
| Linear / Jira / GitHub Issues MCP | Phase 00 intake when the request references a ticket. Pull the ticket; don't paraphrase from the user's summary. |

## Testing

| Tool | When to reach for it |
|---|---|
| Project test runner (`pytest`, `jest`, `go test`, etc.) | Phase 05, every time. |
| Coverage tool | When the change touches risk-sensitive code; not required for every fix. |

## Static analysis & security

| Tool | When to reach for it |
|---|---|
| Project linter (eslint, ruff, golangci-lint, etc.) | Every phase 04/05 run. |
| Semgrep / Bandit / similar | Phase 06 security review on the diff. |
| `npm audit` / `pip-audit` / `cargo audit` | Phase 06 when dependencies changed. |

## File / project tooling

| Tool | When to reach for it |
|---|---|
| Read / Edit / Write (built-in) | Default for file I/O. Always Read before Edit. |
| Make / npm scripts / Taskfile | Project-defined commands; prefer over ad-hoc shell when they exist. |

---

## How to add a new tool to this list

1. Confirm at least one phase or playbook would actually invoke it.
2. Add a row in the right section with a tight "when to reach for it" note.
3. If it's an MCP, add install/config instructions to the appropriate adapter README.
