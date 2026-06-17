# Phase 07 — Delivery

Package the change for handoff. Commits, PR, and any docs the user needs.

## Inputs

- All prior phase artifacts.
- Repo state after phases 04–06.

## Outputs

- Commit(s) on the appropriate branch (only if the user asked for them; otherwise prepare and confirm).
- PR (only if explicitly requested) with title, summary, test plan, and links to session artifacts.
- `sessions/<id>/07-delivery.md` summarizing what was delivered, where, and what the user needs to do next.

## Decision points

- Commit granularity: one commit, several focused commits, or squash later? Default to several focused commits unless the user prefers otherwise.
- Branch strategy: confirm target branch before pushing.

## Tool calls (if available)

- Git — for status, diff, commit, branch.
- GitHub/GitLab CLI or MCP for PR creation **only when explicitly requested**.

## When to ask the user

- Before any push, PR, or visible action — these are high-blast-radius.
- Before adding any co-author or trailer the user hasn't confirmed.

## Exit criteria

- Delivery artifacts exist where the user expects them.
- `07-delivery.md` written.
- **Human approval recorded** — `phases.07-delivery.approval.status: approved` per `playbooks/phase-approval-gate.md`. (This is the phase-boundary approval; it is in addition to the per-action confirmation required before any push/PR above.) Do not advance without it.
- Only then: manifest updated with `phases.07-delivery.status: done` and `current_phase: 08-retrospective`.
