# Phase 02 — Scoping

Define what is in and out of scope. Enumerate cross-module access. **Hard block** on pending access requests.

## Inputs

- `sessions/<id>/01-analysis.md`

## Outputs

- `sessions/<id>/02-scoping.md` with:
  - **In scope**: bullet list of what will be done.
  - **Out of scope**: bullet list of related-but-deferred items.
  - **Modules touched**: every module/repo/system the work needs to read or modify.
  - **Access status**: per module, one of `accessible | needs-grant | unclear`.
- Updated manifest with `access_requests` entries for every module that is `needs-grant` or `unclear`. Each entry starts as `status: pending`.

## Decision points

- Borderline items: ask the user "in or out?" rather than guessing.
- If access to a critical module is denied, the work may not be feasible — escalate.

## Tool calls (if available)

- See `playbooks/ask-for-access.md` for the access-request flow.

## When to ask the user

- For every `pending` access request: emit a single, clear ask. Wait for grant or deny.
- For every borderline scope item.

## Hard block

You may **not** advance to phase 03 while any `access_requests` entry has `status: pending`. This is non-negotiable.

## Exit criteria

- `02-scoping.md` written.
- All `access_requests` are `granted` or `denied` (none `pending`). *(This access hard-block is separate from and runs before the approval gate below.)*
- **Human approval recorded** — `phases.02-scoping.approval.status: approved` per `playbooks/phase-approval-gate.md`. Do not advance without it.
- Only then: manifest updated with `phases.02-scoping.status: done` and `current_phase: 03-planning`.
