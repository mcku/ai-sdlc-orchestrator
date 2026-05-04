# AI-SDLC Orchestrator

A portable, markdown-first framework for running an AI-assisted software development lifecycle across any agentic CLI (Claude Code, Cursor CLI, Gemini CLI, optionally Codex). Same phases, same artifacts, equivalent results — regardless of which agent you point at it.

## Why this exists

Agentic CLIs are powerful but inconsistent. Same request to two different tools produces two different shapes of work. This framework defines the shape — phases, artifacts, decision points, access checkpoints — in plain Markdown, and uses thin per-vendor adapters for ergonomics. The agent does the work; the framework keeps it on rails.

## Install

Clone (or submodule) this repo into your project as `.ai-sdlc/`, then run the installer:

```sh
git clone <this-repo> .ai-sdlc
./.ai-sdlc/install.sh        # auto-detects which CLIs you use and wires them up
```

The installer **symlinks** routing files into the right places (`.claude/skills/`, `.cursor/rules/`, `.gemini/GEMINI.md`, `AGENTS.md`). Symlinks mean the framework is the single source of truth — `git pull` inside `.ai-sdlc/` updates routing automatically with no re-install. On systems without symlink support (e.g. Windows without dev mode) the installer falls back to copying tiny stubs that point at `.ai-sdlc/ENTRY.md`; since stubs are stable, the fallback stays reliable.

Other useful installer modes:

```sh
./.ai-sdlc/install.sh --check                    # dry run; show what would happen
./.ai-sdlc/install.sh claude-code cursor-cli     # explicit adapters instead of auto-detect
./.ai-sdlc/install.sh --uninstall                # remove installer-placed links/files
./.ai-sdlc/install.sh --force                    # overwrite existing files at target paths
```

Manual install instructions per adapter (rarely needed):

- **Claude Code** → `adapters/claude-code/README.md`
- **Cursor CLI** → `adapters/cursor-cli/README.md`
- **Gemini CLI** → `adapters/gemini-cli/README.md`
- **Codex** (stretch) → `adapters/codex/README.md`

## Use

Tell the agent (canonical phrase or natural language both work):

> Run AI-SDLC.

> use the sdlc orchestrator on this

The adapter routes to `ENTRY.md`, which boots the agent through the framework: load `INDEX.md`, resolve or create a session under `sessions/`, run the skill-gap check, and execute phases sequentially.

## What it covers

Intake → analysis → scoping (with hard-block on cross-module access) → planning → development → QA → security → delivery → retrospective. The retrospective proposes updates to the framework itself, gated by `self-improvement/update-rules.md`.

## Updating

Already have an older `.ai-sdlc/` checked out in your project? See [`UPDATING.md`](UPDATING.md). For symlink-based installs, the update is just `cd .ai-sdlc && git pull`.

## Key files for humans

- [`PRINCIPLES.md`](PRINCIPLES.md) — what the framework values and why
- [`INDEX.md`](INDEX.md) — every file and its purpose
- [`UPDATING.md`](UPDATING.md) — how to update an existing install
- [`tools/well-known-tools.md`](tools/well-known-tools.md) — MCPs/CLIs you should install for full power

## Status

v0 skeleton. Expect changes. The strict pieces (manifest schema, phase shape, update rules) are settled; playbooks, adapters, and tool catalog grow incrementally.
