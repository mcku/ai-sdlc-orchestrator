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

- If exactly one active session exists → resume it.
- If none → create `sessions/<YYYY-MM-DD-slug>/manifest.yaml` from the user's request and start at phase 00.
- If multiple → ask the user which to resume.

The slug is a 2–4 word kebab summary of the request (e.g. `checkout-bug`, `add-stripe-webhook`).

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
