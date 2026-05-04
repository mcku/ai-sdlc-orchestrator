# 00 — Intake

## Normalized request

Checkout returns a 500 for users who:

1. Have a saved card on file, AND
2. Have a subscription item in their cart at the time of checkout.

Users without a saved card or without a subscription item are unaffected.

## Source

- Support ticket: SUP-1842
- First reported: 2026-05-02
- Affected users (per support): ~3% of checkouts since 2026-04-30

## Type

`bug`

## Constraints

- Customer-facing, blocks revenue. Treat as P1.
- Patch should ship to production within 48h if feasible.

## Open questions surfaced at intake

- Did anything ship around 2026-04-30 that touched checkout or saved-card handling? (Investigate in phase 01.)
