# AI-SDLC Orchestrator

A portable, markdown-first framework for running an AI-assisted software development lifecycle across any agentic CLI (Claude Code, Cursor CLI, Gemini CLI, optionally Codex). Same phases, same artifacts, equivalent results — regardless of which agent you point at it.

## Why this exists

Agentic CLIs are powerful but inconsistent. Same request to two different tools produces two different shapes of work. This framework defines the shape — phases, artifacts, decision points, access checkpoints — in plain Markdown, and uses thin per-vendor adapters for ergonomics. The agent does the work; the framework keeps it on rails.

## Install

Clone (or submodule) this repo into your project as `.ai-sdlc/`:

```sh
git clone <this-repo> .ai-sdlc
```

Then install the adapter for your CLI of choice:

- **Claude Code** → see `adapters/claude-code/README.md`
- **Cursor CLI** → see `adapters/cursor-cli/README.md`
- **Gemini CLI** → see `adapters/gemini-cli/README.md`
- **Codex** (stretch) → see `adapters/codex/README.md`

## Use

Tell the agent (canonical phrase or natural language both work):

> Run AI-SDLC.

> use the sdlc orchestrator on this

The adapter routes to `ENTRY.md`, which boots the agent through the framework: load `INDEX.md`, resolve or create a session under `sessions/`, run the skill-gap check, and execute phases sequentially.

## What it covers

Intake → analysis → scoping (with hard-block on cross-module access) → planning → development → QA → security → delivery → retrospective. The retrospective proposes updates to the framework itself, gated by `self-improvement/update-rules.md`.

## Key files for humans

- [`PRINCIPLES.md`](PRINCIPLES.md) — what the framework values and why
- [`INDEX.md`](INDEX.md) — every file and its purpose
- [`tools/well-known-tools.md`](tools/well-known-tools.md) — MCPs/CLIs you should install for full power

## Status

v0 skeleton. Expect changes. The strict pieces (manifest schema, phase shape, update rules) are settled; playbooks, adapters, and tool catalog grow incrementally.
