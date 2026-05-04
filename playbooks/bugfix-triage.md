# Playbook — Bugfix triage

Used when phase 00 tags the request as a bug. Bias toward minimal, well-understood fixes; resist scope creep.

## Steps

1. **Reproduce before fixing.** A bug you can't reproduce isn't a bug you understand. Capture the exact reproduction in `01-analysis.md`:
   - Inputs / state required
   - Steps
   - Expected vs. actual

   If you can't reproduce, return to the user with what you tried — don't guess at fixes.

2. **Find the root cause, not the surface symptom.** The first place a bug becomes visible is rarely where it originates. Walk the call stack / data flow back until you find where the invariant first breaks. Document the trace in `01-analysis.md`.

3. **Decide the fix scope deliberately.** Three options, in increasing scope:
   - **Surgical**: fix exactly the broken line/function. Lowest risk, may leave related issues lurking.
   - **Local refactor**: fix the bug and tighten the immediate surroundings (e.g., add a missing invariant check). Moderate risk, prevents recurrence in nearby code.
   - **Structural**: the bug points to a design flaw; fix the design. High risk, deferred unless the user explicitly approves.

   Default to **surgical**. Escalate to local refactor only if the same root cause likely lurks in multiple places. Never go structural without user approval.

4. **Add a regression test that fails before the fix and passes after.** This goes in phase 05 outputs but plan it in phase 03. If the codebase has no test infrastructure for this area, surface that in `03-planning.md` and ask the user how to proceed.

5. **Check for siblings.** Same root cause elsewhere? Grep for the pattern. If found, list them in `03-planning.md` — let the user decide whether they're in scope.

6. **Be skeptical of "fixed by passing more args" / "fixed by adding a try/catch."** These often paper over the real problem. If your fix doesn't make you understand *why* the original code was wrong, you probably haven't fixed it.

## Anti-patterns

- Editing until the symptom goes away without understanding why.
- Adding error handling to swallow the failure.
- "While I'm here" refactors. Note them as follow-ups; don't bundle them.
- Fixing in a place you happen to know rather than where the root cause lives.
