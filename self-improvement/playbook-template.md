# Playbook — `<short verb-led name>`

> Replace this header with a one-line description of what the playbook does. Then fill the sections below. Keep it short — playbooks are for the agent, not for documentation.

## When to invoke

- One bullet per concrete trigger. The agent should be able to recognize "this is the situation" without ambiguity.

## Steps

1. Numbered steps. Each step is an action the agent takes.
2. If a step has a decision branch, name it explicitly ("if X, do A; otherwise do B").
3. Reference other playbooks by relative path when relevant (`see playbooks/foo.md`).

## Anti-patterns

- One bullet per common mistake the agent (or a previous run) might make.
- Be specific. "Don't be sloppy" is useless; "don't catch the exception just to silence the test" is actionable.

---

## Authoring notes (delete this section in the final file)

- Keep the playbook focused on one situation. If you find yourself writing "and also when…", it's two playbooks.
- Reference, don't restate. If a phase already covers something, link to it.
- No prose paragraphs unless absolutely required. Bullets and numbered steps are the format.
- File name: kebab-case, verb-led where possible (`ask-for-access.md`, `bugfix-triage.md`, `migrate-data.md`).
