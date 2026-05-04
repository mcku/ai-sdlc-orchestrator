# 02 — Scoping

## In scope

- Fix the 500 error in checkout for the saved-card + subscription combination.
- Add a regression test covering this combination.
- Confirm no related code paths fail with the same root cause.

## Out of scope

- Subscription renewal flow improvements (separate session if needed).
- Refactoring of saved-card storage layer (long-standing tech debt; not implicated here).
- UI changes to checkout (the bug is server-side).

## Modules touched

| Module | Access | Notes |
|---|---|---|
| `checkout-service` | accessible | primary fix target |
| `payments-service` | needs-grant → **granted** | read-only; confirm webhook event shape |
| `users-service` | accessible | read-only; confirm saved-card data structure |

## Access requests

All resolved. See `manifest.yaml` `access_requests`.

## Hard-block status

✅ No `pending` access requests. Cleared to advance to phase 03.
