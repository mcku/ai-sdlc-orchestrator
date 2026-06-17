# Phase 03 — Planning

Produce a concrete design and task breakdown.

## Inputs

- `sessions/<id>/02-scoping.md`

## Outputs

- `sessions/<id>/03-planning.md` with:
  - Design sketch (interfaces, data flow, key decisions)
  - Task list (ordered, each task small enough to execute and verify independently)
  - Test strategy (what proves it works)
  - Rollback / undo plan (how to revert if it goes wrong)

## Decision points

- Multiple viable designs: present options with trade-offs, let the user pick.
- Migration / data shape changes: confirm with user before committing to an approach.

## Tool calls (if available)

- Context7 MCP for any framework/library APIs the design depends on.
- Code-intel for impact analysis on the proposed touch-points.

## When to ask the user

- Any design choice with non-trivial trade-offs.
- Any task that depends on infrastructure changes.

## Exit criteria

- `03-planning.md` written.
- **Human approval recorded** — `phases.03-planning.approval.status: approved` per `playbooks/phase-approval-gate.md`. The plan must be explicitly approved before any code is written; do not advance without it.
- Only then: manifest updated with `phases.03-planning.status: done` and `current_phase: 04-development`.
