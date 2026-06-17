# Phase 01 — Analysis

Decompose the request, surface unknowns, and identify which parts of the system are touched.

## Inputs

- `sessions/<id>/00-intake.md`
- Local repo state (read-only at this phase)

## Outputs

- `sessions/<id>/01-analysis.md` containing:
  - Decomposition: sub-questions / sub-tasks
  - Affected modules / files (best-effort, marked confidence)
  - Unknowns and assumptions (flagged for user review)
  - Risks worth surfacing early

## Decision points

- Does the request contradict the current code? Flag and ask.
- Are there obvious cheaper alternatives? Mention them.

## Tool calls (if available)

- Code search / grep / Glob to map affected files.
- Code-intel MCP (LSP, references) for cross-module impact.
- Context7 MCP for any library/framework versions referenced.

## When to ask the user

- Any unknown that would change the design substantively.
- Any assumption that, if wrong, invalidates planning.

## Exit criteria

- `01-analysis.md` written.
- **Human approval recorded** — `phases.01-analysis.approval.status: approved` per `playbooks/phase-approval-gate.md`. Do not advance without it.
- Only then: manifest updated with `phases.01-analysis.status: done` and `current_phase: 02-scoping`.
