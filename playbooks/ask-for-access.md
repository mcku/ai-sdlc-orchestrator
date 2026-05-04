# Playbook — Ask for access

Used by phase 02 (scoping) when work needs access to a module/repo/system the agent doesn't currently have. The phase **hard-blocks** until every such ask is resolved.

## When to invoke

- A file path referenced in the analysis isn't readable from the current working tree.
- An API or service the design depends on requires credentials not present in the env.
- A separate repo or monorepo package isn't checked out.
- A database, secret store, or external tool isn't reachable.

## Steps

1. **Identify the access shortfall precisely.** "Need access to `payments-service`" is too vague. "Need read access to `payments-service/src/webhooks.ts` to confirm the event schema" is actionable.

2. **Record the request in `manifest.yaml`** under `access_requests`:

   ```yaml
   access_requests:
     - module: payments-service
       what: read access to src/webhooks.ts to confirm event schema
       why: need to know which events fire for refunds before designing handler
       requested_at: 2026-05-04T10:30:00Z
       status: pending
   ```

3. **Ask the user once, clearly.** Combine all pending requests into a single message if possible:

   > Phase 02 is blocked on access I don't have. Please grant or deny each:
   > 1. Read access to `payments-service/src/webhooks.ts` — needed to confirm refund event schema.
   > 2. Read-only DB access to `analytics_prod.events` — needed to validate the migration won't break existing queries.

4. **Record the user's response.** Update `status` to `granted` or `denied`, with `decided_at` and any notes.

5. **If denied:** decide whether the work can still proceed without it. If not, escalate — return to phase 02 outputs and either reduce scope or stop the session pending out-of-band action.

6. **If granted:** continue. Do not advance phases until **every** request is `granted` or `denied` (no `pending`).

## Anti-patterns

- Asking for access in vague chunks ("give me access to the backend"). Be surgical.
- Proceeding with stubs/mocks while access is pending. The framework forbids this — it's how mocks-vs-prod divergence bugs ship.
- Asking for write access when read access would do. Default to least privilege.
- Bundling an access ask inside a planning question. Access asks are always a separate, explicit checkpoint.
