# Phase 06 — Security review

Review the change for common security failure modes. Scope to what changed; don't audit the whole codebase.

## Inputs

- Diff from phase 04
- `sessions/<id>/05-qa.md`

## Outputs

- `sessions/<id>/06-security.md` with:
  - Threat surface introduced or modified by this change
  - Checklist results (see below)
  - Issues found and how they were resolved (or deferred with rationale)

## Checklist (apply only what's relevant)

- Input validation at trust boundaries (user input, external APIs)
- AuthN/AuthZ on new endpoints, queries, or files
- Injection (SQL, command, XSS, SSRF, template, prompt)
- Secret handling — no secrets in code, config, logs, or test fixtures
- Crypto — using vetted libraries, no DIY primitives
- Deserialization of untrusted data
- Path traversal / file-write outside expected dirs
- Rate limiting / abuse vectors on new public surface
- Dependency additions — license, maintenance, known CVEs

## Decision points

- Vulnerability with non-trivial fix scope: return to phase 03 to plan the fix.
- Risk that's out of scope but real: file it as a follow-up in `06-security.md` and notify the user.

## Tool calls (if available)

- SAST / linter security rules (semgrep, bandit, etc.) on the diff.
- Dependency audit (`npm audit`, `pip-audit`, etc.) when deps changed.

## When to ask the user

- Any finding the user should know about even if you're not fixing it now.
- Any tradeoff between security strictness and feature requirements.

## Exit criteria

- Checklist applied; findings resolved or explicitly deferred.
- `06-security.md` written.
- **Human approval recorded** — `phases.06-security.approval.status: approved` per `playbooks/phase-approval-gate.md`. Do not advance without it.
- Only then: manifest updated with `phases.06-security.status: done` and `current_phase: 07-delivery`.
