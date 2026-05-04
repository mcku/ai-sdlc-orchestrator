---
name: sdlc-start
description: Run the AI-SDLC framework on the current request. Use when the user says "Run AI-SDLC", "use the sdlc orchestrator", "kick off ai-sdlc", or any natural directive referencing `.ai-sdlc/`. Routes the agent to the framework boot loader so it can execute phases (intake → analysis → scoping → planning → development → QA → security → delivery → retrospective) with strict cross-module access checks and self-improvement.
---

# Run AI-SDLC

The user has invoked the AI-SDLC framework. Do not improvise.

## Step 1 — Verify the framework is present

The framework lives at `.ai-sdlc/` in the project root. Confirm `.ai-sdlc/ENTRY.md` exists. If it does not, tell the user the framework isn't installed and stop.

## Step 2 — Read the entry point

Read `.ai-sdlc/ENTRY.md` and follow its instructions exactly. It will direct you to `INDEX.md`, `PRINCIPLES.md`, the active session manifest, and the current phase file.

## Step 3 — Honor the principles

Especially:

- **Hard block on cross-module access asks** in phase 02. Do not advance until every `access_request` is granted or denied by the user.
- **Ask, don't assume**, at the explicit checkpoints in each phase file.
- **File-first state**: write artifacts and update the manifest before acting.

## Step 4 — Use available tools

See `.ai-sdlc/tools/well-known-tools.md`. Prefer authoritative tool output over training-data inference. Always use Context7 MCP when working with libraries or APIs.

## Step 5 — Be terse

Phase artifacts are the deliverable. Chat output should be short status updates and explicit asks at checkpoints. Don't narrate.
