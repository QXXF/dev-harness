# Code Integrity Audit

Always available. Scales with scope.

Goal: catch logic bugs, state desync, contract regressions, and unsafe assumptions before release.

Use silently during normal implementation. Use the full pipeline when the user explicitly asks for audit, review, nemesis, Feynman, state audit, security review, or bug hunt.

## Activation Threshold

| Scope | Depth |
|---|---|
| Read-only text, pure function, trivial change under 5 lines with no state | Off |
| Any state mutation | Coupled state check |
| Paired operations like create/delete, add/remove, deposit/withdraw | Parity check |
| External calls, cross-module calls, async boundaries | Ordering check |
| Public API, persistence, auth, billing, permissions, concurrency | Full dual-pass |
| Explicit audit request | Full pipeline with findings |

## Feynman Lens

Apply to every state-changing, contract-changing, or security-relevant line.

| Question | Fail Condition |
|---|---|
| WHY: which invariant does this line protect? | Cannot name invariant |
| ORDER: what breaks if this line moves before or after adjacent work? | Race, gap, stale read, or partial write appears |
| CONSISTENCY: does the inverse or parallel operation behave the same way? | Asymmetry without reason |
| ASSUMPTION: what is trusted about caller, input, time, cache, network, or storage? | Trust boundary is unenforced |
| FAILURE: what happens if this operation fails halfway? | Silent failure or unrecoverable partial state |

## State Lens

Use whenever writing or reviewing mutation.

1. Identify every coupled state pair touched by the function.
2. Check that all sides of each pair are updated or invalidated.
3. Compare parallel paths for the same entity or resource.
4. Look for defensive clamps that hide invariant drift.
5. Check retry, cancellation, and repeated-call behavior.

Common coupled pairs:

- `balance <-> ledger entry`
- `entity row <-> search index`
- `cache <-> source of truth`
- `count <-> collection`
- `status <-> timestamp`
- `permission <-> role assignment`
- `token <-> expiry`
- `order <-> payment`
- `position <-> aggregate exposure`
- `view state <-> async task`
- `SwiftUI state <-> model source of truth`

## Paired Operation Parity

Examples:

- create/delete
- add/remove
- enable/disable
- login/logout
- open/close
- subscribe/unsubscribe
- mint/burn
- deposit/withdraw
- start/cancel
- cache/invalidate

Checks:

- If operation A has a guard, operation B needs the same guard or a documented reason.
- If A updates coupled state, B must update or invalidate the same pair.
- If A emits an event, metric, notification, or audit log, B likely needs a matching signal.
- If A is transactional, B should be transactional unless asymmetry is intentional.

## Ordering Checks

Flag these patterns:

| Pattern | Risk |
|---|---|
| External call before local state commit | Reentrancy, duplicate execution, partial failure |
| Cache write before source-of-truth write | Stale or false success |
| Event emitted before transaction commits | Consumers observe state that may roll back |
| UI state updated after uncancelled async response | Stale screen or invalid navigation |
| Permission checked before resource identity is finalized | Authorization bypass |
| Migration writes without backfill or compatibility path | Live data breakage |

## Red Flags

Use one concise inline warning before continuing.

| Pattern | Warning |
|---|---|
| Mutates state A without coupled state B | `WARNING: coupled state gap: [B] not updated` |
| Clamp, fallback, or try/catch hides impossible state | `WARNING: masked invariant drift: trace root cause` |
| Paired operation missing sibling guard | `WARNING: inconsistent guard` |
| External call before state update | `WARNING: ordering risk: commit state before external call or justify` |
| Delete without paired cleanup | `WARNING: orphaned coupled state` |
| Admin or emergency path skips normal invariants | `WARNING: bypass gap` |
| Async response writes into stale UI/model state | `WARNING: stale async state` |

## Multi-Step Sequence Check

For non-trivial features, test mentally or with code:

- Call with value X, then value Y. Does Y account for state left by X?
- Repeat N times with varying input. Does aggregate state drift?
- Retry after partial failure. Is operation idempotent?
- Cancel halfway. Is cleanup correct?
- Run two operations concurrently. Does ordering still preserve invariants?
- Can an attacker or unlucky user reach a state normal UX does not expose?

## Full Audit Pipeline

Use for explicit audit requests.

### Phase 0: Recon

- Identify assets, trust boundaries, state stores, permissions, external calls, and high-value paths.
- Form coupling hypotheses.
- Prioritize novel, recently changed, or high-blast-radius code.

### Pass 1: Feynman

- Walk priority functions end to end.
- Name invariants, assumptions, failure modes, and ordering requirements.
- Record suspects only when traceable.

### Pass 2: State Inconsistency

- Map coupled state.
- Compare paired and parallel operations.
- Check repeated calls, retries, cancellation, and partial failure.

### Pass 3+: Targeted Re-Passes

- Alternate between Feynman and State lenses on suspects.
- Stop at convergence or after 6 total passes.

### Final Verification

Report only verified findings. Each finding needs:

- Coupled state or contract involved.
- Breaking operation.
- Trigger sequence.
- Downstream consequence.
- Code trace with file and line reference.
- Proof of concept, test, or concrete reproduction when possible.

## Output For Explicit Audits

If the user asks for written audit artifacts, create:

- `.audit/findings/feynman-passN.md`
- `.audit/findings/state-passN.md`
- `.audit/findings/verified.md`

If the user only asks for a review in chat, report findings first, ordered by severity. Include residual risk and test gaps after findings.

## Absolute Rules

1. No finding without trigger sequence and consequence.
2. Verify call chains, hooks, modifiers, middleware, generated code, and framework lifecycle before reporting.
3. Treat clamps, fallbacks, and swallowed errors as possible evidence of broken invariants.
4. Findings confirmed by both Feynman and State lenses have highest confidence.
5. Report only verified findings. Label uncertainty explicitly.

