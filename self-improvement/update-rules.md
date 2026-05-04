# Framework update rules

Rules for how the framework changes itself based on phase 08 proposals. These rules are non-negotiable.

## The three kinds of update

| Kind | What it does | Approval | Auto-apply on approval? |
|---|---|---|---|
| `new-playbook` | Adds a new file under `playbooks/` (or `phases/`, `tools/`, etc.) | One ask: "approve adding `<path>`?" | **Yes.** Once the user says yes, the file is written without further per-line approval. |
| `edit-playbook` | Modifies an existing file in the framework | Per-edit approval. Each chunk shown to the user; user approves or rejects each. | No — applied edit-by-edit. |
| `deletion` | Removes content from a framework file or removes a file entirely | **Forbidden.** Never proposed, never applied. |

## Breaking vs. non-breaking (orthogonal to the kinds above)

Every proposal must additionally be classified by the agent as **non-breaking** or **breaking**. Default is non-breaking; breaking requires explicit cost-benefit rationale.

### Non-breaking (preferred)

Safe to apply to existing in-flight sessions. Examples:

- Adding a new playbook, phase, or tool entry (`new-playbook` is almost always non-breaking).
- Adding a new **optional** manifest field.
- Adding a new gate inside an existing phase that only applies on the next run of that phase (existing sessions that already passed the phase aren't retro-validated).
- Clarifying wording in a phase or playbook without changing required behavior.
- Adding new entries to `tools/well-known-tools.md`.

Bumps **MINOR** (or PATCH if purely doc-fix).

### Breaking

Cannot be applied to a session created under a prior MAJOR. Examples:

- Renumbering or removing a phase.
- Renaming a canonical file the boot path or manifest references (`ENTRY.md`, `INDEX.md`, `phases/NN-*.md`, `VERSION`).
- Making a previously-optional manifest field required.
- Changing the boot path itself.
- Changing semantics of `update-rules.md` (these rules).
- Changing what a phase fundamentally does in a way that invalidates artifacts already written under the old definition.

Bumps **MAJOR**. Existing sessions **must finish on the framework version they were created under** — the agent at runtime refuses to apply a newer-MAJOR framework against an older session (see `ENTRY.md` step 3 resume-time check).

### How the agent classifies

When emitting a proposal in phase 08, the agent walks this short test:

1. **Does this change require any existing manifest, phase artifact, or routing file to be rewritten or interpreted differently to keep working?** If yes → breaking.
2. **Does it remove or rename anything that another file references by canonical path?** If yes → breaking.
3. **Does it tighten what was previously optional?** If yes → breaking.
4. Otherwise → non-breaking.

If unsure → classify as breaking. False positives are cheap (just a MAJOR bump that didn't need to be); false negatives corrupt sessions.

### Cost-benefit rule for choosing breaking

The agent should only propose a breaking change when:

- A non-breaking workaround exists but is materially worse (e.g., would leave the framework with two parallel doing-the-same-thing files indefinitely), **and**
- The benefit of the change applies to enough future sessions to outweigh forcing in-flight sessions onto a pinned checkout.

The proposal must include a `rationale` field stating the alternative considered and why breaking won.

## Proposal file format

Each proposal lives in `self-improvement/proposed/<timestamp>-<slug>.md` with this frontmatter:

```yaml
---
kind: new-playbook | edit-playbook
target: playbooks/migrate-data.md
breaking: false                         # or true; default false
version_bump: patch | minor | major     # patch only for non-behavior doc fixes
rationale: >                            # required when breaking: true; recommended otherwise
  Non-breaking alternative would require keeping two parallel "X" playbooks
  indefinitely with no clear sunset. Estimated benefit applies to all sessions
  involving migrations going forward; in-flight migration sessions can finish
  on the pinned 0.4.x checkout.
proposed_by_session: 2026-05-04-checkout-bug
status: pending | approved | rejected
---
```

Body:

- For `new-playbook`: the full proposed file content.
- For `edit-playbook`: a unified diff (or before/after blocks) of what changes.

## Workflow

1. Phase 08 retrospective writes proposal file(s) to `self-improvement/proposed/`, classified per the test above.
2. Agent presents each proposal to the user, surfacing the `breaking` flag and rationale prominently.
3. User responds; agent updates `status` in the frontmatter. User may also override the classification (rare; record their reason).
4. On `approved`:
   - `new-playbook` → write the file, update `INDEX.md`, bump `VERSION` per `version_bump`.
   - `edit-playbook` → walk the diff with the user, apply each chunk on confirmation. Bump `VERSION` per `version_bump`.
   - **If `breaking: true`**: tag the prior commit `v<old-major>.<old-minor>.<old-patch>` in `.ai-sdlc/` so existing sessions can pin to it. See `UPDATING.md`.
5. On `rejected` → leave the proposal in place with `status: rejected` for future reference. **Do not delete it.**

## Sanity checks before any apply

- The proposal does not delete content (reject if it does).
- The target path exists (for edits) or doesn't exist (for new files).
- `INDEX.md` will be updated as part of the apply, not separately.
- `VERSION` will be bumped per `version_bump`.
- If `breaking: true` and the prior version is not yet tagged in git, tag it before applying.

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
