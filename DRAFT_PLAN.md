# AI-SDLC Orchestrator — Draft Plan (v2)

## What we're building

A portable, markdown-first SDLC framework that any agentic CLI (Claude Code, Cursor CLI, Gemini CLI, optionally Codex) can pick up and execute, producing equivalent results. Distributed as its own repo, checked out into each project as `.ai-sdlc/`. Core stays vendor-neutral; thin adapters handle vendor-specific optimizations. The framework self-evaluates before each engagement ("sharpen the blade") and grows its own playbooks over time.

## Decisions locked

| # | Decision |
|---|---|
| 1 | Own repo. Checked out per project as `.ai-sdlc/`. Single fixed entry point so an agent can act on a one-line directive without scanning. |
| 2 | Vendor priority: Claude Code, Cursor CLI (1st-class), Gemini CLI. Codex as stretch. |
| 3 | Build scope: thin v0 skeleton (see "My preference" below). |
| 4 | Sessions are cross-agent resumable. `manifest.yaml` schema is strict. |
| 5 | Self-improvement writeback rule: agent identifies need → asks user → if approved AND it's a new file, auto-accept; if it's in-place edit, require explicit per-edit approval. **Deletion of playbook content is never permitted.** |
| 6 | Cross-module access asks are a **hard block**. No proceeding without user grant/deny on record. |

## Entry-point design (answers Q1's "easy integration")

A single fixed file is the only thing an agent needs to be told about:

```
.ai-sdlc/ENTRY.md       # 20–40 lines, the agent's "boot loader"
.ai-sdlc/INDEX.md       # machine-readable map: every file + one-line purpose
```

`ENTRY.md` tells the agent: "read `INDEX.md`, identify the current phase from `sessions/<active>/manifest.yaml` (or start a new session), then load the matching `phases/NN-*.md` and any playbooks it cites." No directory scan needed — `INDEX.md` is the manifest of the framework itself.

The user-facing directive supports **both** styles:

- **Canonical (robust)**: `Run AI-SDLC.` — exact phrase, guaranteed match across every adapter. Lives in each adapter's trigger config (skill description, Cursor rule, Gemini instruction) so it's recognized verbatim.
- **Natural (ergonomic)**: any free-form phrase that names `.ai-sdlc/` or refers to the framework (e.g., "use the SDLC orchestrator", "kick off ai-sdlc on this bug"). Adapters carry a short list of synonym hints so the agent routes natural phrasing to the same `ENTRY.md` flow.

Both paths land in the same place: read `ENTRY.md` → `INDEX.md` → current phase. The canonical phrase is documented in `README.md` for users who want determinism; natural phrasing is the default daily ergonomic.

## Directory layout

```
ai-sdlc/                            # the framework repo
├── ENTRY.md                        # boot loader (the only file an agent must be told about)
├── INDEX.md                        # map of every file + purpose (kept in sync)
├── README.md                       # human-facing: how to install, how to use
├── PRINCIPLES.md                   # sharpen-blade, ask-don't-assume, file-first state, hard-block on access
├── phases/                         # vendor-agnostic SDLC pipeline
│   ├── 00-intake.md
│   ├── 01-analysis.md
│   ├── 02-scoping.md               # cross-module access asks (hard block)
│   ├── 03-planning.md
│   ├── 04-development.md
│   ├── 05-qa.md                    # test plans, regression, UI testing
│   ├── 06-security.md              # OWASP-style review hooks
│   ├── 07-delivery.md
│   └── 08-retrospective.md         # proposes playbook updates per Q5 rule
├── playbooks/                      # named procedures referenced by phases
│   ├── ask-for-access.md
│   ├── ui-test-with-browser-mcp.md
│   ├── security-review.md
│   ├── bugfix-triage.md
│   └── ...
├── self-improvement/
│   ├── skill-gap-check.md          # mandatory before phase 01
│   ├── playbook-template.md
│   ├── update-rules.md             # encodes the Q5 rule (new file = auto, edit = ask, delete = forbidden)
│   └── proposed/                   # diffs awaiting user approval land here
├── tools/
│   └── well-known-tools.md         # MCPs/CLIs catalog + "when to reach for it"
├── adapters/
│   ├── claude-code/                # skills/, agents/, settings.json snippets
│   ├── cursor-cli/                 # rules / .cursorrules
│   ├── gemini-cli/                 # instructions
│   └── codex/                      # stretch
└── sessions/
    └── <YYYY-MM-DD-slug>/
        ├── manifest.yaml           # strict schema (see below)
        ├── 00-intake.md
        ├── 01-analysis.md
        └── ...
```

Each phase file has a fixed shape: **Inputs · Outputs · Decision points · Tool calls (if available) · When to ask the user · Exit criteria** — so any agent executes it the same way. Adapters translate phases/playbooks into vendor-native form but never change behavior.

## `manifest.yaml` (strict, cross-agent)

```yaml
session_id: 2026-05-04-checkout-bug
created_by: claude-code           # informational only
current_phase: 03-planning
phases:
  00-intake:    {status: done,  artifact: 00-intake.md,    completed_at: ...}
  01-analysis:  {status: done,  artifact: 01-analysis.md,  completed_at: ...}
  02-scoping:   {status: done,  artifact: 02-scoping.md,   completed_at: ...}
  03-planning:  {status: active, artifact: 03-planning.md}
access_requests:
  - module: payments-service
    requested_at: ...
    status: granted | denied | pending   # 'pending' = hard block on advancement
decisions:
  - phase: 02-scoping
    summary: dropped legacy IE11 support
proposed_updates:                  # written by phase 08; processed per Q5 rule
  - kind: new-playbook | edit-playbook
    target: playbooks/foo.md
    diff: ...
    status: pending | approved | rejected
```

Strict schema means a Cursor session can resume a Claude-started one (and vice versa) by reading manifest only.

## "Sharpen the blade" mechanism

Before phase 01, agent runs `self-improvement/skill-gap-check.md`: scan `INDEX.md`, ask "do I have a playbook for this?" If not → draft a new playbook → since it's a new file, ask user once for approval, auto-accept on yes (per Q5). After delivery, phase 08 retrospective emits proposed updates into `self-improvement/proposed/`; in-place edits require per-item approval; deletions are never proposed.

## Hard-block access flow (Q6)

Phase 02 enumerates every module the work touches. For any not currently accessible, agent writes an `access_requests` entry with `status: pending` and **stops**. Cannot advance to 03-planning while any access request is pending. User must explicitly grant/deny; both are recorded.

## My preference on Q3 (build scope)

**Build a thin v0 skeleton now**, not a full v1. Concretely:

- `ENTRY.md`, `INDEX.md`, `README.md`, `PRINCIPLES.md`
- All 9 phase files, but stub-quality (clear shape, light content)
- 2 real playbooks: `ask-for-access.md`, `bugfix-triage.md`
- `self-improvement/` core files
- `tools/well-known-tools.md` with seeded entries
- `adapters/claude-code/` fully wired, `adapters/cursor-cli/` minimal, others as placeholders
- One example session under `sessions/example/` to show the artifact shape

Why: requirements will shift as you use it. A skeleton lets us iterate cheaply; the strict pieces (manifest schema, phase shape, update rule) get nailed down first because they're expensive to change later. Heavier playbooks/adapters can grow incrementally without touching the spine.

---

## Deferred to v1 (not in v0 skeleton)

- **Project-local extensions** (`.ai-sdlc/local/` for per-project playbooks/overrides that don't flow upstream). Skeleton will leave the path unused but `INDEX.md` will note it as a reserved future location so v1 can slot in without restructuring.

## Ready to scaffold

All six original questions and both follow-ups are resolved. v0 skeleton plan as described in "My preference on Q3" above is the build target.
