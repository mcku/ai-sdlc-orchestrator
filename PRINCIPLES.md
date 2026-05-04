# Principles

These rules override agent defaults while AI-SDLC is active.

## 1. Sharpen the blade before swinging

Before phase 01 of any new session, run `self-improvement/skill-gap-check.md`. If the framework lacks a relevant playbook, draft one and confirm with the user **before** starting work. Time spent improving the framework compounds; time spent ad-libbing does not.

## 2. Ask, don't assume

When a decision depends on context the agent doesn't have, ask the user. Especially:

- Ambiguous scope ("does this include the mobile client?")
- Missing acceptance criteria
- Trade-offs the user hasn't expressed a preference on

A short question now is cheaper than a wrong implementation later.

## 3. File-first state

Every non-trivial decision, scope item, access request, and artifact is written to a file under `sessions/<id>/` **before** acting on it. The session manifest is the source of truth — agents resume from the manifest, not from chat history. This is how cross-agent continuity works (Claude Code → Cursor CLI → Gemini and back).

## 4. Hard-block on cross-module access

Phase 02 enumerates every module/repo/system the work might touch. Anything not currently accessible becomes an `access_request` in the manifest with `status: pending`. **The agent may not advance past phase 02 while any request is pending.** User explicitly grants or denies; both are recorded.

## 5. Tool use over guessing

When an MCP, CLI, or other tool can answer a question authoritatively (file presence, schema, API surface, current docs), use it. Do not infer from training data. See `tools/well-known-tools.md` for the catalog and "when to reach for it" notes.

## 6. Evolve the framework, never erode it

Phase 08 may propose framework updates per `self-improvement/update-rules.md`:

- New file → auto-accepted on user approval (one ask)
- In-place edit → per-edit user approval required
- Deletion of playbook content → **never permitted**

The framework grows monotonically. If a playbook is wrong, edit it (with approval). If it's outdated, supersede it with a new file and mark the old one deprecated — but the content stays.

## 7. Vendor-neutral by default

Phases and playbooks are written so any competent agent can execute them with plain Markdown alone. Vendor-specific affordances (Claude Code skills, Cursor rules, Gemini instructions) live in `adapters/` and add ergonomics — they never change behavior. If you find yourself encoding vendor logic into a phase, stop and move it to the adapter.
