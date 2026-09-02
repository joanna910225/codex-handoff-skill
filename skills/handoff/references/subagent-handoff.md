# Subagent Handoff

Every spawned subagent returns a compact, evidence-preserving handoff to its immediate parent. Use it as the subagent's final response or checkpoint response. Do not return only a conversational summary.

During long work, the subagent also runs the continuity gate in [context-rotation.md](context-rotation.md). When context becomes unreliable or a materially different phase begins, it returns to the main agent instead of trying to continue indefinitely in the same subagent thread.

## Return Contract

```markdown
# Subagent Handoff

## Delegation
- Parent objective:
- Delegated task and acceptance criteria:
- Agent/model/effort:
- Read-only or exact write scope:

## Status
- `COMPLETE`, `PARTIAL`, `BLOCKED`, or `STOPPED`:
- Scope actually completed:
- Scope not completed:

## Verified outcomes
- Finding, implementation, or artifact:

## Changed files
- `path`: purpose and ownership state

## Verification evidence
- `command` or inspection: observed result
- Not run or still unverified:

## Decisions, assumptions, and rejected paths
- Decision or assumption:
- Rejected or failed approach and evidence:

## Risks and blockers
- Risk/blocker:

## Parent integration contract
- What the parent must verify:
- What the parent must not assume:
- Conflicts or dependencies with other agents:

## Unique next action
- Parent integration action, or the next action for a continuation agent:

## Continuation routing
- Rotation signals or phase change:
- Recommended model/effort if more work is needed:
- Escalate or replace only if:
```

Omit empty optional sections, but never omit delegation, status, verification state, parent integration contract, or unique next action.

## Status Rules

- `COMPLETE`: acceptance criteria are met within the delegated scope. The unique next action tells the parent how to verify or integrate the result.
- `PARTIAL`: useful verified work exists, but the delegated acceptance criteria are not fully met. State the exact remaining boundary.
- `BLOCKED`: progress requires a decision, permission, dependency, or evidence the subagent does not have.
- `STOPPED`: the parent redirected or interrupted the work. Preserve the last verified safe state and identify anything left mid-operation.

## Recursive Handoffs

A subagent that spawns children acts as the parent for its delegated scope. It must:

1. give each child the same handoff contract;
2. wait for required child packets;
3. verify or clearly mark unverified child claims;
4. merge their verified outcomes into its own handoff;
5. reference unresolved child packets and conflicts instead of hiding them in a synthesized summary.

## Parent Responsibilities

- Do not equate `COMPLETE` with accepted. Reopen changed files, inspect the diff, and rerun the smallest material verification.
- Reconcile overlapping findings and conflicting state before assigning new work.
- Do not close or replace a thread until its handoff is received, unless an urgent stop is required. When no packet is available, record the agent state as unverified.
- For continuation after context degradation or a phase change, the main agent verifies the old packet and spawns a fresh subagent. Do not resume the old subagent merely because its thread still exists.
- Keep secrets, credentials, raw hidden reasoning, and large logs out of the packet. Use safe local artifact references when needed.
