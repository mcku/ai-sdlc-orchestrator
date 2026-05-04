# AI-SDLC Orchestrator — Draft Plan

## What we're building

A portable, markdown-first SDLC framework that any agentic CLI (Claude Code, Cursor CLI, Gemini CLI, …) can pick up and execute, producing equivalent results. Core stays vendor-neutral; thin adapters handle vendor-specific optimizations. The framework self-evaluates before each engagement ("sharpen the blade") and grows its own playbooks over time.

## Proposed directory layout

```
ai-sdlc/
├── README.md                # how to use; pick your adapter
├── PRINCIPLES.md            # sharpen-blade, ask-don't-assume, file-first state
├── phases/                  # the SDLC pipeline, vendor-agnostic prose
│   ├── 00-intake.md
│   ├── 01-analysis.md
│   ├── 02-scoping.md        # incl. cross-module access asks
│   ├── 03-planning.md
│   ├── 04-development.md
│   ├── 05-qa.md             # test plans, regression, UI testing
│   ├── 06-security.md       # OWASP-style review hooks
│   ├── 07-delivery.md
│   └── 08-retrospective.md  # feeds back into playbooks/
├── playbooks/               # named procedures phases reference
│   ├── ask-for-access.md
│   ├── ui-test-with-browser-mcp.md
│   ├── security-review.md
│   ├── bugfix-triage.md
│   └── ...
├── self-improvement/
│   ├── skill-gap-check.md   # mandatory step before phase 01
│   ├── skill-template.md
│   └── playbook-template.md
├── tools/
│   └── well-known-tools.md  # MCPs/CLIs catalog + "when to reach for it"
├── adapters/
│   ├── claude-code/         # skills/, agents/, settings.json snippets
│   ├── cursor-cli/          # rules/instructions
│   └── gemini-cli/
└── sessions/
    └── <YYYY-MM-DD-slug>/
        ├── manifest.yaml    # phase status, decisions, access asks, links
        ├── 00-intake.md
        ├── 01-analysis.md
        └── ...
```

Each phase file has a fixed shape — **Inputs**, **Outputs**, **Decision points**, **Tool calls (if available)**, **When to ask the user** — so any agent can execute it the same way. Adapters just translate phases/playbooks into the vendor's preferred form (Claude Code skills, Cursor rules, Gemini instructions); they don't fork the logic.

## How "sharpen the blade" works

Before phase 01, the agent runs `self-improvement/skill-gap-check.md`: read the request, scan `phases/` and `playbooks/`, ask "do I have a procedure for this?" If not, draft a new playbook *first* and have the user confirm, then proceed. Phase 08 retrospective writes learnings back into playbooks (proposed as a diff, not auto-merged — TBD, see Q5).

## Cross-vendor equivalence strategy

Phase docs are written so a competent agent with no vendor-specific features can still execute them — plain Markdown, explicit steps, explicit "ask the user when X." Adapters add ergonomics (e.g. Claude Code gets a `/sdlc-start` skill that just runs `phases/00-intake.md`), but never change behavior. Determinism comes from the phase contracts, not the adapter.

## Cross-module access handling

Phase 02 includes a hard checkpoint: list every module/repo/system the work might touch, and for each one not currently accessible, generate an explicit ask to the user *before* development starts. Logged in `manifest.yaml` so it survives across agents.

## Tool/MCP guidance

`tools/well-known-tools.md` catalogs by purpose (search, code intel, browser, db, secrets, design, web) with "when to reach for it" notes — so the agent prefers tool use over guessing, and the human knows what to install.

---

## Questions before building anything

1. **Distribution model**: should this live as its own repo and be checked out per project, or installed *into* each project as `.ai-sdlc/`? Affects how `sessions/` is stored.
2. **Target vendors**: just Claude Code / Cursor CLI / Gemini CLI, or also Aider, Codex CLI, etc.?
3. **Build scope today**: scaffold a working v0 (skeleton + a few real playbooks) here in `/home/user/2026/ai-sdlc-orchestrator/`, or produce a fuller written spec first and build after review?
4. **Cross-agent session continuity**: should a session started in Claude Code be resumable in Cursor CLI? If yes, the manifest schema needs to be strict (and minimal YAML).
5. **Self-improvement writeback**: when phase 08 wants to update a playbook, edit directly, or always emit a proposed diff for the user to approve?
6. **Access-ask gating**: hard block until the user grants/denies, or soft warn-and-proceed-with-stubs?
