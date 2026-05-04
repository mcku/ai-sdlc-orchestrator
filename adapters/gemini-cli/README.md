# Gemini CLI adapter

Placeholder adapter. v0 ships with routing instructions only; richer integration follows once Gemini CLI's agentic surface stabilizes.

## Install

From the project root:

```sh
mkdir -p .gemini
cp .ai-sdlc/adapters/gemini-cli/GEMINI.md .gemini/GEMINI.md
```

(The exact filename and location may differ depending on Gemini CLI version. The intent: place the file where Gemini CLI loads project-level instructions.)

## How it works

`GEMINI.md` instructs the agent to recognize the canonical phrase **"Run AI-SDLC."** and natural variants, then read `.ai-sdlc/ENTRY.md` and follow it.

## Status

Placeholder — the routing instruction is the entire integration in v0. As Gemini CLI grows skill/agent equivalents, this adapter will too.
