# Updating AI-SDLC

How to move a project from a previous version of `.ai-sdlc/` to the latest. Most installs need a one-line update; a few edge cases need extra care.

## TL;DR

```sh
cd .ai-sdlc && git pull && cd ..
./.ai-sdlc/install.sh --check          # see if any routing files are out of sync
./.ai-sdlc/install.sh --force          # re-sync any that are
```

For symlink-based installs, the `git pull` alone is usually enough. The installer commands above handle every edge case below.

---

## Knowing what you have

```sh
cat .ai-sdlc/VERSION
```

For finer-grained history (between version bumps):

```sh
git -C .ai-sdlc log -n 5 --oneline
```

Each session's manifest also records the framework version it was started under as `framework_version`. Old sessions without that field predate versioning (pre-`0.2.0`); the agent backfills with the current version on resume.

---

## Case 1 — You installed via the installer with symlinks (the common case)

**Symptom:** files like `.claude/skills/sdlc-start.md`, `.cursor/rules/sdlc.mdc` show as symbolic links (`ls -la` shows `->`).

**Update:**

```sh
cd .ai-sdlc && git pull && cd ..
```

That's it. Symlinks already point into `.ai-sdlc/adapters/...`, so updates to routing files are picked up automatically. The framework body (phases, playbooks, principles, tool catalog) lives entirely in `.ai-sdlc/` and is also picked up automatically — the agent reads it at runtime via `ENTRY.md` → `INDEX.md`.

**Verify:**

```sh
./.ai-sdlc/install.sh --check
```

Should report `exists` for every route. If it reports `would install` for any, your symlink got broken — re-run `./.ai-sdlc/install.sh --force` to replace it.

## Case 2 — You installed via the installer with copy fallback (Windows-without-dev-mode, or symlink-restricted FS)

**Symptom:** routing files are real files (not links), and the first line contains `Managed by .ai-sdlc/install.sh`.

**Update:**

```sh
cd .ai-sdlc && git pull && cd ..
./.ai-sdlc/install.sh --force
```

`--force` overwrites the existing copies with the new content (or symlinks, if the FS now supports them). Safe because the installer detects its own marker before overwriting.

## Case 3 — You manually copied files (pre-installer, or one-off `cp`)

**Symptom:** routing files are real files (not links), and the first line is **not** the installer's `Managed by` marker.

**Update:**

```sh
cd .ai-sdlc && git pull && cd ..
./.ai-sdlc/install.sh --check
```

The installer's `--check` will tell you the routing files exist but aren't installer-managed. Two options:

- **Recommended:** delete the manual copies and let the installer place fresh symlinks.

  ```sh
  rm .claude/skills/sdlc-start.md .claude/agents/sdlc-orchestrator.md \
     .cursor/rules/sdlc.mdc .gemini/GEMINI.md AGENTS.md   # only the ones you have
  ./.ai-sdlc/install.sh
  ```

- **Manual sync:** re-copy from `.ai-sdlc/adapters/<vendor>/` over your existing files. Repeat after every framework update.

## Case 4 — You're using Cursor's older `.cursorrules` instead of `.cursor/rules/`

The installer doesn't manage `.cursorrules` (the file may already contain other rules). After updating:

```sh
diff .cursorrules .ai-sdlc/adapters/cursor-cli/sdlc.mdc
```

If the routing block in `.cursorrules` is out of date, replace just the AI-SDLC section by hand. Migrating to `.cursor/rules/sdlc.mdc` is the cleaner long-term path:

```sh
mkdir -p .cursor/rules
./.ai-sdlc/install.sh cursor-cli
# then manually remove the AI-SDLC routing block from .cursorrules
```

---

## What the new version requires (post-v0.1)

Some updates introduce new framework requirements. Check whether your project meets them:

### Coverage gate (phase 05)

Phase 05 now requires **≥ 80% diff coverage** on added/changed code, using free/OSS tooling. See `playbooks/coverage-gate.md`.

- If your project already runs coverage in CI: nothing to do — the agent uses what's there.
- If not: install a coverage tool for your language (e.g. `pytest-cov` for Python, `c8` for Node, `go test -cover` for Go) and `diff-cover` to score the diff. The agent will ask before adding dev dependencies.

### Pre-commit gate (phase 05)

Phase 05 now runs `pre-commit run` against the diff after tests and coverage pass. See `playbooks/pre-commit-gate.md`.

- The gate **assumes** Python and `pre-commit` are installed and `.pre-commit-config.yaml` exists.
- If any of those are missing, the gate is skipped with a recorded reason — it does not block. But the retrospective will surface the gap.
- To enable it: `pip install pre-commit` (or `pipx install pre-commit`), add a `.pre-commit-config.yaml`, and run `pre-commit install`.

### Per-project gate config (added in 0.3.0)

Gates can now be **disabled** or set to **manual-trigger** per project via `.ai-sdlc.yaml` at the project root. See `config.example.yaml` for the full schema. Defaults are unchanged (every gate enabled), so existing projects without a config behave identically — non-breaking.

```yaml
# .ai-sdlc.yaml
gates:
  coverage: { enabled: manual, threshold: 80 }   # only runs when user asks
  pre_commit: { enabled: false }                  # skipped entirely
  ui_test: { enabled: true }                      # default
```

### Coverage gate language-awareness (changed in 0.3.0)

Earlier versions of `playbooks/coverage-gate.md` recommended `diff-cover` (a Python tool) as the cross-language default. That caused `diff-cover` to be invoked in non-Python repos (Go, Rust, etc.), pulling Python in as a transitive requirement. Fixed: the playbook now detects the project language and prefers native diff-coverage tooling. `diff-cover` is only used when Python is already a project dependency. Non-breaking — same gate, same threshold, just a smarter tool selection.

### Phase approval gate (added in 0.4.0)

Every phase now ends with a **mandatory human approval gate**: the agent stops after each phase, summarizes it, and may not advance `current_phase` until the user explicitly approves and that approval is recorded in the manifest under `phases.NN.approval`. See `playbooks/phase-approval-gate.md`.

- **Nothing to install or configure.** The gate is on by default and **cannot** be disabled — there is no `.ai-sdlc.yaml` key for it and no override flag. (The QA-style gates remain configurable; this one is not.)
- `phases.NN.approval` is a **new optional manifest field**. Existing sessions resume fine: any phase already marked `done` is treated as previously approved (not retro-validated); the gate applies to the next phase boundary onward. This is why the change is **non-breaking** (MINOR bump to 0.4.0).
- Practically: expect the agent to pause and ask "approve advancing to phase NN?" after each phase instead of rolling straight through.

### Settings allowlist (Claude Code only)

If you previously merged `adapters/claude-code/settings.example.json` into `.claude/settings.json`, re-diff after pulling to see if new safe permissions were added:

```sh
diff <(jq -S .permissions.allow .claude/settings.json) \
     <(jq -S .permissions.allow .ai-sdlc/adapters/claude-code/settings.example.json)
```

Merge any new entries you want. The installer doesn't touch `settings.json` because it's project-owned.

---

## Compatibility contract

What the framework guarantees across versions, so existing sessions don't break under your feet.

### Versioning scheme

`MAJOR.MINOR.PATCH` (semver-ish, applied to the framework as a whole).

- **PATCH** (`0.2.0` → `0.2.1`): bug fixes, doc clarifications, new tool catalog entries. No behavior change for existing sessions.
- **MINOR** (`0.2.0` → `0.3.0`): additive only — new phases, new playbooks, new optional manifest fields, new gates that apply only to future phase runs. Existing sessions resume without modification.
- **MAJOR** (`0.x` → `1.0`): may renumber phases, rename canonical files, or make a manifest field required. Old sessions need explicit migration; the agent will halt resume until the user confirms.

Pre-1.0 caveat: the `0.x` line is intentionally still mutable. We minimize breaking changes but reserve the right to make them at MINOR boundaries when needed for v1 readiness — and we document each one in this file.

### Stable across all v0.x

These will not change without a MAJOR bump:

- The boot path: `ENTRY.md` → `INDEX.md` → session manifest → `phases/NN-*.md`.
- The set of phase numbers `00`–`08` and what each phase covers (additions are MINOR; renumbering is MAJOR).
- The hard-block on `access_requests` with `status: pending` in phase 02.
- The human approval gate at every phase boundary (added 0.4.0): no phase advances without an explicit, recorded human approval. Non-configurable; removing or weakening it would be a MAJOR change.
- The update rules in `self-improvement/update-rules.md`: new file = auto on user yes, in-place edit = per-edit approval, deletion = forbidden.
- The minimum required manifest fields (`session_id`, `framework_version`, `created_at`, `current_phase`, `status`, `phases.*`).
- The principle: agent reads framework files at runtime; routing files in adapter destinations are stable, tiny stubs.

### May change at MINOR (additive)

- New phases (inserted with non-conflicting numbers, never replacing existing ones).
- New playbooks.
- New optional manifest fields. Old sessions without them keep working.
- New required gates *within* a phase. They apply to future runs of that phase only; sessions that already passed it are not retro-validated.
- New tools in `tools/well-known-tools.md`.
- New adapters.

### May change at MAJOR (breaking)

- Phase renumbering or removal.
- Manifest fields becoming required when they weren't.
- Renaming routing files (would orphan old symlinks; `install.sh --force` resolves it but symlinks predating the rename break first).
- Changing the `update-rules.md` semantics.
- Changing the boot path (`ENTRY.md` → `INDEX.md` → manifest → phases).

When a MAJOR is cut:

- This file gains a "Migrating from `0.x` to `1.0`" section with concrete steps.
- The agent's resume-time version check halts unconditionally on MAJOR mismatch (no force flag).
- The prior MAJOR is tagged in git so existing sessions can pin to it (see "Finishing an in-flight session under a prior MAJOR" below).
- Phase 08 retrospective only proposes breaking changes when the cost-benefit clearly favors breaking — see `self-improvement/update-rules.md`.

## In-flight sessions

If you have a session under `sessions/<id>/` with `status: in_progress` from a previous version:

- **Same-MAJOR upgrade (e.g. `0.1.0` → `0.2.0`):** existing sessions resume normally. The manifest schema is forward-compatible across all `0.x` minors.
- **New required gates** (e.g. coverage, pre-commit) apply on the *next* phase run. If the session has already completed that phase, gates are not retro-run.
- **If you want to apply new gates retroactively**, manually set the relevant `phases.NN-name.status` back to `pending` and re-run.
- **MAJOR upgrade (e.g. `0.x` → `1.0`):** existing sessions **must finish on the framework version they were created under**. The agent halts on resume if the framework MAJOR differs from the manifest. There is no force flag. See the recipe below.

## Finishing an in-flight session under a prior MAJOR

When the framework crosses a MAJOR boundary while a session is in flight, the cleanest path is a parallel pinned checkout. Two options:

### Option A — git worktree (preferred if your `.ai-sdlc/` is its own git repo)

```sh
# from the project root
PRIOR_TAG=v0.5.3                                    # whatever the session's framework_version is
git -C .ai-sdlc worktree add ../.ai-sdlc-pin-${PRIOR_TAG} ${PRIOR_TAG}
ln -sfn ../.ai-sdlc-pin-${PRIOR_TAG} .ai-sdlc-pinned

# point the agent at the pinned checkout for this session only
# (one-shot; don't change the project-level adapter symlinks)
```

Tell the agent:

> Resume session `<id>` using `.ai-sdlc-pinned/ENTRY.md` instead of `.ai-sdlc/ENTRY.md`. The session predates the current framework MAJOR.

When the session is `done`, remove the pinned worktree:

```sh
git -C .ai-sdlc worktree remove ../.ai-sdlc-pin-${PRIOR_TAG}
rm .ai-sdlc-pinned
```

### Option B — separate clone (if worktrees aren't available)

```sh
git clone <framework-repo> ../.ai-sdlc-pin-${PRIOR_TAG}
git -C ../.ai-sdlc-pin-${PRIOR_TAG} checkout ${PRIOR_TAG}
ln -sfn ../.ai-sdlc-pin-${PRIOR_TAG} .ai-sdlc-pinned
```

Same agent instruction as Option A.

### Notes

- The session's artifacts live under the pinned checkout's `sessions/` (because the session was created there). You don't need to copy them anywhere — the pinned checkout already has them.
- New sessions for the same project can use the upgraded `.ai-sdlc/` normally. Only the in-flight session is pinned.
- Once all sessions created under the prior MAJOR are `done`, retire the pinned checkout.

## Tagging convention (for framework maintainers)

Every release is tagged in the framework repo:

```sh
git -C .ai-sdlc tag -a v0.2.0 -m "release 0.2.0"
git -C .ai-sdlc push --tags
```

Tags must be cut **before** applying any breaking change, so prior-MAJOR sessions can pin to the last commit on the old MAJOR. The proposal-apply workflow in `self-improvement/update-rules.md` enforces this: a `breaking: true` proposal is gated on the prior version being tagged.

---

## Rollback

If an update breaks something:

```sh
cd .ai-sdlc
git log --oneline -n 20             # find the prior commit you want
git checkout <sha>
cd ..
./.ai-sdlc/install.sh --force       # re-sync routing to the older version
```

To return to current:

```sh
cd .ai-sdlc && git checkout main && git pull && cd ..
./.ai-sdlc/install.sh --force
```

---

## Uninstall

Pulling out cleanly:

```sh
./.ai-sdlc/install.sh --uninstall    # removes installer-placed links/copies
rm -rf .ai-sdlc                      # removes the framework itself
```

Sessions under `.ai-sdlc/sessions/` go with the framework. If you want to keep them, move them out first:

```sh
mv .ai-sdlc/sessions ./ai-sdlc-sessions-archive
```
