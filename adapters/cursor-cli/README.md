# Cursor CLI adapter

Wires AI-SDLC into Cursor CLI via a project rule.

## Install

From the project root:

```sh
./.ai-sdlc/install.sh cursor-cli
```

This symlinks `.cursor/rules/sdlc.mdc` → `.ai-sdlc/adapters/cursor-cli/sdlc.mdc`. Updates flow automatically via `git pull` in `.ai-sdlc/`.

### Manual fallback (no installer)

```sh
mkdir -p .cursor/rules
ln -s ../../.ai-sdlc/adapters/cursor-cli/sdlc.mdc .cursor/rules/sdlc.mdc
```

For older Cursor versions that read `.cursorrules` instead of `.cursor/rules/`, append the routing text once: `cat .ai-sdlc/adapters/cursor-cli/sdlc.mdc >> .cursorrules`. The installer doesn't manage `.cursorrules` because it's project-owned and may already contain other rules.

## How it works

The rule tells Cursor's agent to recognize the canonical phrase **"Run AI-SDLC."** and natural variants, then read `.ai-sdlc/ENTRY.md` and follow it. All actual logic stays in `.ai-sdlc/`.

## Usage

```
> Run AI-SDLC.
> use the sdlc orchestrator
```

## Status

This adapter is intentionally minimal in v0. As Cursor's agentic features mature, this will gain a richer rule set and (where supported) skill-equivalent triggers. For now it relies on plain rule-text routing — the same approach used by the Gemini and Codex placeholders.
