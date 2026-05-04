# AI-SDLC — File Index

Machine-readable map of the framework. The agent uses this instead of scanning directories.

## Root

- [`ENTRY.md`](ENTRY.md) — agent boot loader; the only file an adapter needs to point at.
- [`INDEX.md`](INDEX.md) — this file.
- [`README.md`](README.md) — human-facing install and usage.
- [`UPDATING.md`](UPDATING.md) — how to move an existing install to a newer version.
- [`PRINCIPLES.md`](PRINCIPLES.md) — operating rules that override agent defaults.
- [`VERSION`](VERSION) — current framework version; stamped into every new session manifest.
- [`install.sh`](install.sh) — adapter installer (auto-detect, symlink, copy fallback, uninstall).

## Phases (`phases/`)

- [`00-intake.md`](phases/00-intake.md) — capture and normalize the raw request.
- [`01-analysis.md`](phases/01-analysis.md) — decompose, surface unknowns, identify modules touched.
- [`02-scoping.md`](phases/02-scoping.md) — in/out scope; emit access requests; **hard block** on pending asks.
- [`03-planning.md`](phases/03-planning.md) — design and task breakdown.
- [`04-development.md`](phases/04-development.md) — implementation; prefers tool use over guessing.
- [`05-qa.md`](phases/05-qa.md) — test plans, regression, UI testing.
- [`06-security.md`](phases/06-security.md) — OWASP-style review hooks.
- [`07-delivery.md`](phases/07-delivery.md) — PR / handoff artifacts.
- [`08-retrospective.md`](phases/08-retrospective.md) — capture learnings; propose framework updates.

## Playbooks (`playbooks/`)

- [`ask-for-access.md`](playbooks/ask-for-access.md) — how to identify, request, and record cross-module access.
- [`bugfix-triage.md`](playbooks/bugfix-triage.md) — reproduce → root cause → minimal fix → regression.
- [`coverage-gate.md`](playbooks/coverage-gate.md) — phase 05 gate: ≥ 80% diff coverage on added/changed code.
- [`pre-commit-gate.md`](playbooks/pre-commit-gate.md) — phase 05 gate: run `pre-commit run` against the diff after tests pass.

## Self-improvement (`self-improvement/`)

- [`skill-gap-check.md`](self-improvement/skill-gap-check.md) — pre-flight check run before phase 01.
- [`playbook-template.md`](self-improvement/playbook-template.md) — shape for new playbooks.
- [`update-rules.md`](self-improvement/update-rules.md) — when an update is auto-accepted vs. needs approval; deletion forbidden.
- `proposed/` — diffs awaiting user approval land here.

## Tools (`tools/`)

- [`well-known-tools.md`](tools/well-known-tools.md) — catalog of MCPs/CLIs by purpose with "when to reach for it" notes.

## Adapters (`adapters/`)

- [`claude-code/`](adapters/claude-code/) — fully wired adapter: skills, agents, settings snippets.
- [`cursor-cli/`](adapters/cursor-cli/) — minimal adapter (rule file).
- [`gemini-cli/`](adapters/gemini-cli/) — placeholder.
- [`codex/`](adapters/codex/) — placeholder (stretch).

## Sessions (`sessions/`)

- `<YYYY-MM-DD-slug>/manifest.yaml` — strict, cross-agent session state.
- `<YYYY-MM-DD-slug>/NN-*.md` — phase artifacts.
- [`example/`](sessions/example/) — reference session showing artifact shape.

## Reserved (not present in v0)

- `local/` — reserved future location for project-local playbooks/overrides that don't flow upstream. Do not use yet.
