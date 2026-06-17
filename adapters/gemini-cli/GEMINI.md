# Project instructions — AI-SDLC routing

When the user's message contains any of:

- The canonical phrase `Run AI-SDLC.`
- Natural variants ("use the sdlc orchestrator", "kick off ai-sdlc", "start ai-sdlc on this", "run the sdlc framework")
- Any directive referencing `.ai-sdlc/`

…then read `.ai-sdlc/ENTRY.md` and follow its instructions exactly.

Do not improvise your own SDLC. The framework defines phases, artifacts, decision points, access checks, and update rules. Honor `.ai-sdlc/PRINCIPLES.md` — especially the **human approval gate at every phase boundary** (never advance to the next phase without the user's explicit approval, recorded in the manifest), the hard-block on cross-module access in phase 02, and the prohibition on deleting framework content.

Prefer tool use over guessing; see `.ai-sdlc/tools/well-known-tools.md`.

If `.ai-sdlc/ENTRY.md` does not exist, tell the user the framework isn't installed and stop.
