# Phase 08 — Retrospective

Capture what was learned and propose framework updates. This is how AI-SDLC sharpens itself.

## Inputs

- All prior phase artifacts in this session.

## Outputs

- `sessions/<id>/08-retrospective.md` covering:
  - What went well
  - What went badly (and where the friction was)
  - What was missing from the framework that would have helped
  - What was wrong in the framework
- Zero or more proposals in `self-improvement/proposed/`, each in its own file.

## Proposal kinds

Per `self-improvement/update-rules.md`:

- **`new-playbook`** — adds a new file under `playbooks/`. On user approval: auto-accepted (no per-edit confirmation).
- **`edit-playbook`** — modifies an existing playbook or phase. On user approval: applied. Requires explicit per-edit approval.
- **`deletion`** — **never permitted.** Supersede with a new file and mark the old deprecated instead.

## Classification (mandatory)

Every proposal must be tagged `breaking: true | false` with a `version_bump`. Walk the classification test in `self-improvement/update-rules.md`:

1. Would this require any existing manifest, phase artifact, or routing file to be rewritten / interpreted differently to keep working? If yes → breaking.
2. Does it remove or rename anything referenced by canonical path? If yes → breaking.
3. Does it tighten what was previously optional? If yes → breaking.
4. Otherwise → non-breaking.

If unsure, classify as breaking. **Default is non-breaking** — choose breaking only when the cost of the workaround clearly outweighs forcing in-flight sessions onto a pinned checkout. Provide a `rationale` field.

The user always sees the classification and may override it (rare).

## Decision points

- Lesson learned: is it general (→ propose framework update) or session-specific (→ stays in retrospective only)?
- Multiple lessons: bundle related ones into a single proposal; keep unrelated ones separate.

## When to ask the user

- Always, before finalizing each proposal.

## Exit criteria

- `08-retrospective.md` written.
- Each proposal in `self-improvement/proposed/` has a clear status (`pending`, `approved`, `rejected`).
- Approved proposals applied per the update rules.
- Manifest updated with `status: done`.
