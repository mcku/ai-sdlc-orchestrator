# Phase 00 — Intake

Capture and normalize the raw user request into a session artifact.

## Inputs

- The user's free-form directive (the message that triggered AI-SDLC).
- Any files, links, or context the user attached.

## Outputs

- `sessions/<id>/manifest.yaml` — created if not present. Canonical shape: `sessions/example/manifest.yaml`. Required fields documented in `ENTRY.md` step 3. **Always stamp `framework_version` from the framework root `VERSION` file** so future agents can detect compat at resume time.
- `sessions/<id>/00-intake.md` — normalized statement of the work.

## Decision points

- Is this one task or several? If several, ask whether to split into separate sessions.
- Is the request a bug, feature, refactor, investigation, or other? Tag it; downstream phases branch on this.

## Tool calls (if available)

- File search / grep to confirm referenced files actually exist.
- Issue tracker MCP (if configured) to pull linked tickets.

## When to ask the user

- The request references something ambiguous ("the checkout bug" — which one?).
- No deadline or priority signal and the work looks non-trivial.
- The request implies access to systems not obviously available locally.

## Exit criteria

- `00-intake.md` contains: normalized statement, type tag, any constraints/deadlines, links to source materials.
- Manifest exists with `current_phase: 01-analysis`.
