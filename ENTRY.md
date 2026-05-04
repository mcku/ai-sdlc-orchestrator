# AI-SDLC — Agent Entry Point

You are an agentic CLI executing the AI-SDLC framework. Follow these steps. Do not improvise around them.

## 1. Load the framework map

Read `INDEX.md` (sibling of this file). It lists every file in this framework with a one-line purpose. Use it to navigate — do **not** scan directories.

## 2. Read the principles

Read `PRINCIPLES.md`. These rules override your defaults for this run:
- **Sharpen the blade** before swinging it.
- **Ask, don't assume**, especially for cross-module access.
- **File-first state** — every decision is written to disk before you act on it.
- **Hard-block on access** — if a module isn't accessible and you need it, stop and ask.

## 3. Resolve the active session

Look for `sessions/<dir>/manifest.yaml` with `status` not equal to `done`.

- If exactly one active session exists → resume it. **Run the version check below before continuing.**
- If none → create `sessions/<YYYY-MM-DD-slug>/manifest.yaml` from the user's request and start at phase 00. Stamp the manifest with the current framework version (read `VERSION` at the framework root and write its contents into the manifest field `framework_version`).
- If multiple → ask the user which to resume.

The slug is a 2–4 word kebab summary of the request (e.g. `checkout-bug`, `add-stripe-webhook`).

The canonical manifest shape is `sessions/example/manifest.yaml`. New sessions must include at minimum: `session_id`, `framework_version`, `created_at`, `current_phase`, `status`, `phases.*`, `access_requests` (may be empty), `decisions` (may be empty), `proposed_updates` (may be empty).

### Version check on resume

Compare the manifest's `framework_version` against the current `VERSION`:

- **Equal** → proceed.
- **Manifest version older, same major (e.g. `0.1.0` vs `0.2.0`)** → safe per the compatibility contract in `UPDATING.md`. Note the upgrade in chat ("Resuming session created under v0.1.0 on framework v0.2.0; new gates apply to future phase runs only.") and proceed.
- **Manifest version newer than current** → halt. Tell the user the framework was downgraded; instruct them to upgrade `.ai-sdlc/` to at least the manifest's version. Do not proceed until the framework is upgraded or the user explicitly accepts after acknowledging the risk in writing.
- **Major version differs (manifest's MAJOR < current MAJOR)** → **halt unconditionally**. Per principle 8 and `self-improvement/update-rules.md`, breaking changes never run on existing sessions. Tell the user:
  > This session was created under framework v`<X.y.z>`, but the framework is now v`<X'.y'.z'>` with a different MAJOR. Breaking changes cannot be applied to existing sessions. Finish this session under the original framework version (see `UPDATING.md` "Finishing an in-flight session under a prior MAJOR" for the pinned-checkout recipe), then upgrade for new sessions.
  
  Do **not** offer a "force" or "accept the risk" option. There is none.
- **`framework_version` missing** (session predates versioning) → backfill it with the current `VERSION` value, note the assumption in chat, and proceed. (Pre-versioning sessions are by definition pre-`0.2.0`; same-major safe.)

## 4. Run the skill-gap check (only when starting a new session)

Before phase 01, execute `self-improvement/skill-gap-check.md`. If a playbook is missing, propose one and ask the user before continuing. Per `self-improvement/update-rules.md`: new files are auto-accepted on user approval; in-place edits require per-edit approval; deletion is never permitted.

## 5. Execute the current phase

Read `phases/NN-*.md` matching `current_phase` in the manifest. Each phase file has a fixed shape:

- **Inputs** — what must already exist
- **Outputs** — what you must produce
- **Decision points** — branches where you may need to ask the user
- **Tool calls (if available)** — preferred MCP/CLI usage; see `tools/well-known-tools.md`
- **When to ask the user** — explicit checkpoints
- **Exit criteria** — what must be true to advance

Write the phase artifact (`sessions/<id>/NN-*.md`), update the manifest, then advance.

## 6. On phase 02 (scoping): respect the access hard-block

If any `access_requests` entry is `pending`, you may **not** advance to phase 03. Ask the user, record their grant/deny, and only then proceed.

## 7. On phase 08 (retrospective): propose framework updates

Write proposals into `self-improvement/proposed/`. Follow `self-improvement/update-rules.md` for what may be auto-accepted vs. requires approval.

---

If the user's directive is the canonical phrase **"Run AI-SDLC."** or any natural variant ("use the SDLC orchestrator", "kick off ai-sdlc on this", etc.), you are already in the right place. Begin at step 1.
