# Playbook — Phase approval gate

Used at **every** phase boundary (00 → 01 → … → 08 → done). No phase may advance to the next until the human has explicitly approved the completed phase and that approval is recorded in the manifest. This is non-negotiable and **not** configurable via `.ai-sdlc.yaml` — unlike the QA gates, it can never be disabled or set to `manual`.

## When to invoke

- You have finished a phase: its artifact (`NN-*.md`) is written and every other exit criterion for that phase is met.
- You are about to update `current_phase` in the manifest (or, for phase 08, about to set `status: done`).

Invoke this gate **before** that update — never after.

## Steps

1. **Confirm the phase is actually complete.** Every non-approval exit criterion in `phases/NN-*.md` is satisfied and the artifact is written. Do not ask for approval of a half-finished phase.

2. **Present a concise approval request to the user.** One message containing:
   - Which phase just completed and a 2–5 line summary of its artifact (key decisions, scope, results).
   - What the **next** phase will do.
   - Anything the user should weigh before approving (open risks, deferrals, assumptions).
   - The explicit ask: *"Approve advancing to phase MM, request changes, or reject?"*

3. **Wait for an explicit human decision.** Do not advance on silence, on a tool result, or on your own judgment that the phase "looks done." Only a clear human signal counts.

4. **Record the decision in the manifest** under `phases.NN.approval`:

   ```yaml
   phases:
     03-planning:
       status: done                 # only set to done once approval.status == approved
       artifact: 03-planning.md
       completed_at: 2026-05-04T10:05:00Z
       approval:
         status: approved           # pending | approved | changes-requested | rejected
         by: user                   # who approved (name/handle if given)
         at: 2026-05-04T10:10:00Z   # ISO-8601
         notes: "go ahead"          # optional: verbatim or paraphrased decision
   ```

5. **Branch on the decision:**
   - **`approved`** → set `phases.NN.status: done`, write the approval block, *then* update `current_phase` to the next phase (or `status: done` for phase 08).
   - **`changes-requested`** → keep the phase active (`current_phase` unchanged). Address the feedback, update the artifact, and re-run this gate from step 1.
   - **`rejected`** → keep the phase active. Ask the user how they want to proceed (rework, reduce scope, or stop the session). Do not advance.

6. **Never set `current_phase` to the next phase while `phases.NN.approval.status` is anything other than `approved`.** If you find yourself about to advance without an `approved` block, stop — you are violating the gate.

## Interaction with other gates

- This gate is **in addition to** every phase's existing checkpoints. It does not replace the phase 02 access hard-block (`playbooks/ask-for-access.md`) or the phase 05 QA gates — those still run first. The approval gate is always the **last** thing before advancing.
- The QA gates in `.ai-sdlc.yaml` can be disabled or set to `manual`. This gate cannot. There is no config key for it and no `--force` override.

## Anti-patterns

- **Auto-advancing because exit criteria are "objectively" met.** Meeting the exit criteria makes the phase *eligible* for approval; it does not grant approval. A human still says yes.
- **Treating a question as approval.** "What about X?" is not "approved." Resolve it, then ask again.
- **Batching approvals.** Do not ask the user to "approve phases 03 through 07 up front." Each phase is approved when it completes, against its actual artifact — not speculatively.
- **Advancing first and asking later.** The manifest must show `approval.status: approved` *before* `current_phase` moves. Order matters; it is the audit trail.
- **Recording approval the user didn't give.** Never backfill an `approved` block to unblock yourself.
