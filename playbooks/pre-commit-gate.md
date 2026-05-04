# Playbook — Pre-commit gate

Used at the end of phase 05 (QA), after tests and coverage pass. Runs the project's [`pre-commit`](https://pre-commit.com/) hooks against the changed files. Catches the lint/format/security checks the project has already standardized on, before delivery.

## Configuration (read first)

Before running, check the project's `.ai-sdlc.yaml` `gates.pre_commit` section:

- `enabled: true` (default) → run the gate.
- `enabled: false` → skip entirely; record `skipped (disabled by .ai-sdlc.yaml)` and continue.
- `enabled: manual` → do not auto-run; only run when the user explicitly asks. Record `skipped (manual mode; not invoked this run)`.

This gate also auto-skips (regardless of config) when its prerequisites aren't met — see "Assumptions" below.

## Assumptions

- Python is installed.
- `pre-commit` is installed (`pip install pre-commit`, `pipx install pre-commit`, or via the project's dev-dependency manifest).
- The project has a `.pre-commit-config.yaml` at the repo root.

If any of these is missing, the gate auto-skips with the specific reason recorded in `05-qa.md`. Do **not** silently install `pre-commit` or Python — ask the user first.

## Steps

1. **Verify the toolchain is present:**

   ```sh
   command -v pre-commit && pre-commit --version
   ```

   If missing → ask the user how to install (don't silently `pip install`).
   If `.pre-commit-config.yaml` is missing → note it in `05-qa.md` and skip this gate. Surface as a finding for phase 08 retrospective.

2. **Run pre-commit on the changed files:**

   ```sh
   pre-commit run --from-ref "$(git merge-base HEAD origin/main)" --to-ref HEAD
   ```

   For uncommitted changes, run against staged files:

   ```sh
   git add -u && pre-commit run
   ```

   Or against everything in the working tree (slower, broader):

   ```sh
   pre-commit run --all-files
   ```

   Default to the diff-scoped run unless the project's convention is otherwise.

3. **If hooks pass** → record the run output (or exit code + summary) in `05-qa.md`. Done.

4. **If hooks fail:**
   - Many hooks **auto-fix** (formatters, import sorters). After they fix, files are modified — re-stage and re-run.
   - Hooks that don't auto-fix (e.g., custom checks, security scanners) require manual remediation. Address each finding:
     - **Real issue** → fix and re-run.
     - **False positive on this change** → ask the user before adding any per-line exemption (`# noqa`, `eslint-disable`, etc.). Don't silence checks unilaterally.
     - **Hook is broken** → don't paper over it; surface in retrospective.

5. **Never use `--no-verify`** to bypass hooks during commits. The whole point of this gate is that the project has decided these checks must pass; bypassing defeats it.

6. **Record results** in `05-qa.md`:
   - Whether the gate ran (or was skipped, with reason)
   - Hooks that ran and their outcomes
   - Any auto-fixes applied (these become part of the diff)

## Interaction with the coverage gate

Run the **coverage gate first**. If coverage failed, you may have to add tests; pre-commit will then check the new test files too. Running pre-commit before adding tests means re-running it after.

## Exit criteria

- `pre-commit run` exits 0 on the relevant files, or
- The gate is explicitly skipped (no config / tooling missing), with reason recorded in `05-qa.md`.

## Anti-patterns

- Using `git commit --no-verify` to skip hooks. Never.
- Silently `pip install`ing `pre-commit` when it's missing. Ask first.
- Auto-fixing and committing without re-running the test suite. Auto-fixes can change behavior (rare but possible); re-run tests after.
- Adding broad exemptions (`# noqa`, file-level disables) instead of fixing the underlying issue.
