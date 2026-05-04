# Claude Code adapter

Wires AI-SDLC into Claude Code so the canonical phrase **"Run AI-SDLC."** (and natural variants) routes the agent to `ENTRY.md`.

## Install

From the project root (where `.ai-sdlc/` is checked out):

1. Copy the skill file:

   ```sh
   mkdir -p .claude/skills
   cp .ai-sdlc/adapters/claude-code/skills/sdlc-start.md .claude/skills/
   ```

2. (Optional) Copy the orchestrator subagent:

   ```sh
   mkdir -p .claude/agents
   cp .ai-sdlc/adapters/claude-code/agents/sdlc-orchestrator.md .claude/agents/
   ```

3. (Optional) Merge the suggested permission allowlist from `settings.example.json` into `.claude/settings.json` to reduce permission prompts during phase execution.

## How it works

- The skill `sdlc-start.md` declares trigger phrases (canonical + natural variants). When Claude Code recognizes one, it loads the skill, which simply tells the agent: read `.ai-sdlc/ENTRY.md` and follow it.
- The optional `sdlc-orchestrator` subagent can be invoked when the user wants the work delegated to a fresh context (useful for long sessions).
- All actual logic lives in `.ai-sdlc/`. Updating the framework updates behavior across all sessions without touching `.claude/`.

## Usage

Inside a project that has `.ai-sdlc/`:

```
> Run AI-SDLC.
> use the sdlc orchestrator on this checkout bug
> kick off ai-sdlc to plan the migration
```

Any of these route to the same flow.
