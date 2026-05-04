# Codex adapter (stretch / placeholder)

Placeholder for OpenAI Codex CLI integration. Not a v0 priority; included so the structure is in place when the user is ready.

## Intended install

From the project root:

```sh
cp .ai-sdlc/adapters/codex/AGENTS.md AGENTS.md
```

(Exact filename depends on Codex CLI's instruction-loading conventions.)

## How it will work

Same pattern as the other adapters: `AGENTS.md` instructs the agent to route the canonical phrase **"Run AI-SDLC."** (and natural variants) to `.ai-sdlc/ENTRY.md`. Logic stays in the framework.

## Status

Placeholder. Promote to first-class once the user prioritizes it.
