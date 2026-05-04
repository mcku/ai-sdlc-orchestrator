# Framework update rules

Rules for how the framework changes itself based on phase 08 proposals. These rules are non-negotiable.

## The three kinds of update

| Kind | What it does | Approval | Auto-apply on approval? |
|---|---|---|---|
| `new-playbook` | Adds a new file under `playbooks/` (or `phases/`, `tools/`, etc.) | One ask: "approve adding `<path>`?" | **Yes.** Once the user says yes, the file is written without further per-line approval. |
| `edit-playbook` | Modifies an existing file in the framework | Per-edit approval. Each chunk shown to the user; user approves or rejects each. | No — applied edit-by-edit. |
| `deletion` | Removes content from a framework file or removes a file entirely | **Forbidden.** Never proposed, never applied. |

## Why deletion is forbidden

Removing playbook content silently throws away learning. If a playbook is wrong, propose an `edit-playbook` to fix it. If a playbook is obsolete, supersede it: write a new playbook, and add a one-line `Deprecated: see <new>.md` note at the top of the old one (this is itself an `edit-playbook` proposal). The old content stays available for reference.

## Proposal file format

Each proposal lives in `self-improvement/proposed/<timestamp>-<slug>.md` with this frontmatter:

```yaml
---
kind: new-playbook | edit-playbook
target: playbooks/migrate-data.md
proposed_by_session: 2026-05-04-checkout-bug
status: pending | approved | rejected
---
```

Body:

- For `new-playbook`: the full proposed file content.
- For `edit-playbook`: a unified diff (or before/after blocks) of what changes.

## Workflow

1. Phase 08 retrospective writes proposal file(s) to `self-improvement/proposed/`.
2. Agent presents each proposal to the user.
3. User responds; agent updates `status` in the frontmatter.
4. On `approved`:
   - `new-playbook` → write the file, update `INDEX.md`, move proposal to `self-improvement/proposed/applied/` (or just leave with `status: approved`).
   - `edit-playbook` → walk the diff with the user, apply each chunk on confirmation.
5. On `rejected` → leave the proposal in place with `status: rejected` for future reference. **Do not delete it.**

## Sanity checks before any apply

- The proposal does not delete content (reject if it does).
- The target path exists (for edits) or doesn't exist (for new files).
- `INDEX.md` will be updated as part of the apply, not separately.
