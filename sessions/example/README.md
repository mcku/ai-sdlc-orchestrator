# Example session

This directory shows the shape of a session in flight. It is **not** real work — it's reference material so an agent (or human) can see what artifacts look like at each phase.

Files present:

- `manifest.yaml` — strict cross-agent state, mid-session (`current_phase: 03-planning`)
- `00-intake.md` — normalized request, type tag, constraints
- `02-scoping.md` — in/out scope, modules touched, access status

Phases 01 and 03–08 are intentionally absent in the example to keep it short. Real sessions will have one artifact per completed phase.

When starting a new real session, **do not** use the `example` directory. Create a fresh one named `<YYYY-MM-DD-slug>` per `ENTRY.md` step 3.
