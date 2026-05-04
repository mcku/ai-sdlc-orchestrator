# Phase 04 — Development

Execute the plan. One task at a time. Tool use over guessing.

## Inputs

- `sessions/<id>/03-planning.md`

## Outputs

- Code changes in the repo.
- `sessions/<id>/04-development.md` — running log of tasks completed, deviations from plan, decisions made mid-flight.

## Decision points

- Plan turns out to be wrong: stop, update `03-planning.md` (in-place edit OK; this is session state, not framework state), then continue.
- New unknown surfaces: if it changes scope, return to phase 02 briefly.

## Tool calls (if available)

- Editor / language-server tools for typed edits.
- Test runner for each task's verification step.
- Context7 MCP for any library API the plan references — confirm current syntax, don't trust training data.
- See `tools/well-known-tools.md` for the full catalog.

## When to ask the user

- A planned task can't be done without an approach the user hasn't seen.
- You discover something that suggests the plan is materially wrong.

## Exit criteria

- All tasks in the plan are done or explicitly deferred (with note).
- Code compiles / lints / type-checks.
- `04-development.md` log up to date.
- Manifest updated with `current_phase: 05-qa`.
