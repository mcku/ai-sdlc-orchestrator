# AI-SDLC routing

When the user's message includes the canonical phrase `Run AI-SDLC.` or any natural variant ("use the sdlc orchestrator", "kick off ai-sdlc", etc.), or references `.ai-sdlc/` directly:

1. Read `.ai-sdlc/ENTRY.md` and follow it exactly.
2. Do not improvise your own SDLC.
3. Honor the rules in `.ai-sdlc/PRINCIPLES.md` — especially the hard-block on cross-module access in phase 02, and the prohibition on deleting framework content.
4. Prefer tool use over guessing. See `.ai-sdlc/tools/well-known-tools.md`.

If `.ai-sdlc/ENTRY.md` is missing, tell the user the framework isn't installed and stop.
