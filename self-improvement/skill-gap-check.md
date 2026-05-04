# Skill-gap check

Run this **once**, at the start of every new session, before phase 01. (Skip on resumed sessions — the check already ran.)

## Purpose

Before doing the work, check whether the framework has the right tools for the job. If not, fix the framework first. This is the "lumberjack sharpens the blade" step.

## Steps

1. **Read the request** (already in `00-intake.md`).

2. **Scan the index, not the directories.** Open `INDEX.md`. Note which playbooks already exist.

3. **For the type of work in this session, ask:**
   - Is there a playbook that matches the *kind* of work? (bug → `bugfix-triage`; access need → `ask-for-access`; etc.)
   - Are there phases or playbooks that look adjacent but don't quite fit?
   - Is there a recurring concern (e.g., "this is a data migration, and we have no migration playbook") that warrants a new playbook?

4. **If a relevant playbook exists**, no action needed. Proceed to phase 01.

5. **If a playbook is clearly missing**, draft one using `playbook-template.md` and ask the user:

   > Before starting, I notice there's no playbook for `<X>`. I'd like to add `playbooks/<slug>.md`. Approving this auto-accepts the new file (per the update rules); want me to proceed?

   - User approves → write the new playbook, then proceed to phase 01.
   - User declines → proceed to phase 01 without it; note the gap in the eventual retrospective.

6. **If an existing playbook looks subtly wrong** for this case, do **not** edit it during the gap-check. Note the concern; let phase 08 retrospective propose the edit (which will need per-edit approval).

## Anti-patterns

- Spending more than a few minutes on the gap-check. It's a calibration step, not a redesign session.
- Creating speculative playbooks ("this might be useful someday"). Only create when the current session genuinely needs it.
- Editing existing playbooks here. That's phase 08's job, with stricter approval.
