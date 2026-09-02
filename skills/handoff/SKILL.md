---
name: handoff
description: Proactively assess context health and phase boundaries, then create or consume an evidence-preserving handoff and route remaining work across a fresh main chat or cost-appropriate subagents. Use when work becomes long, compacted, repetitive, contradictory, forgetful, changes phase or ownership, or the user asks to continue elsewhere; not for routine status updates.
---

# Handoff

Transfer unfinished work without transferring the old conversation's noise. Preserve observable state, decisions, acceptance criteria, and verification evidence; do not preserve hidden reasoning or unrelated history. Keep the main chat focused on orchestration, consequential decisions, integration, and final verification; move bounded work to subagents using the least expensive model and reasoning effort that can reliably complete it.

Prepare the handoff while the source context is still at its richest reliable state. **Do not compact merely to hand off:** compaction only summarizes the current chat and does not make a fresh chat inherit it. If compaction already happened, recover facts from authoritative files and observable state, and mark anything that cannot be recovered as unknown.

## Decide Whether to Hand Off

Use a handoff when at least one of these applies:

- The user asks to continue in a new chat, thread, session, or agent.
- Context was compacted or important decisions are being lost, reread, or contradicted.
- The same approach failed twice without new evidence.
- The task is changing phase, interface, directory ownership, or required agent profile.
- A long-running task needs a durable stopping point before it can continue safely.

Prefer a short checkpoint or direct steering when the task is small, the state remains clear, and the same agent can continue reliably. Do not create a fresh thread merely to report progress.

## Run the Continuity Gate Automatically

Read [references/context-rotation.md](references/context-rotation.md) and evaluate the continuity gate without waiting for the user:

- before starting a distinct new phase;
- after context compaction or a context-pressure warning;
- when the agent repeats reads or work, contradicts accepted decisions, loses track of changed files, or cannot restate the goal, acceptance criteria, verified state, and unique next action;
- after major steering, ownership, interface, or model changes;
- when a subagent reports `PARTIAL`, `BLOCKED`, `STOPPED`, or requests continuation.

Choose `CONTINUE`, `CHECKPOINT`, or `ROTATE`. Do not rotate merely because a thread is old; rotate when the current context is no longer a reliable or coherent unit for the next work.

- **Main-agent rotation:** collect active subagent handoffs, produce the full handoff packet, release write ownership, and move continuation to a fresh main chat. If the interface cannot create a fresh chat, stop with a ready-to-use packet and state that user action is required.
- **Subagent rotation:** the old subagent returns a `Subagent Handoff` to the main agent. The main agent verifies it, closes or stops the old writer, chooses the next model, and spawns a fresh subagent with only the verified packet and necessary files. Do not transfer directly from old subagent to new subagent without the main agent accepting the packet.

## Plan Agent and Model Routing

For non-trivial remaining work, read [references/model-routing.md](references/model-routing.md) before preparing or consuming the handoff.

- Do not let subagents inherit an expensive main-chat model by accident. Specify the subagent model and reasoning effort explicitly when the interface allows it.
- Prefer subagents for bounded exploration, implementation, verification, and review whose inputs and outputs can be stated clearly and checked independently.
- Keep trivial or tightly sequential work in one agent when delegation overhead would exceed the work itself.
- Record the chosen main-agent role, each subagent's task and model, and the escalation condition in the handoff packet.

## Require Subagent Handoffs

Before spawning any subagent, read [references/subagent-handoff.md](references/subagent-handoff.md) and include its compact return contract in the spawn prompt.

- Every subagent must return a `Subagent Handoff` to its parent, including agents that finish successfully. A generic prose summary is not sufficient.
- The handoff must distinguish `COMPLETE`, `PARTIAL`, `BLOCKED`, and `STOPPED`, preserve verification evidence and changed-file ownership, and name one parent or continuation action.
- If a subagent spawns child agents, it becomes their parent for that scope and must require the same handoff recursively, then merge or reference the child packets in its own return.
- Before steering or stopping a subagent, request a handoff at the next safe boundary when practical. If an urgent stop prevents one, mark that subagent's state as unverified rather than guessing.
- The parent agent must inspect the returned packet and verify material artifacts before integrating the result or closing the thread.

## Prepare a Handoff

1. Stop mutations at a safe boundary. Preserve valid work; do not roll it back merely to make the packet cleaner.
2. Inspect the observable state relevant to the task. When applicable, check the workspace root, repository, worktree, branch, commit, dirty state, changed files, and current diff.
3. Separate verified facts from user decisions, working assumptions, and unverified claims. For each material decision that constrains the remaining work, preserve the concise causal chain: evidence or trigger, chosen path and why, and rejected alternatives and why. Do not copy the transcript or hidden reasoning.
4. Inventory continuation prerequisites. Never include a secret value; include its purpose, safe source or locator, approved retrieval/materialization mechanism, verified availability, and the exact user or approval action needed if absent. Record external-state dependencies and authorization caps with what has already been consumed and what remains.
5. Run the smallest relevant non-destructive verification that is already authorized. Record exact commands and outcomes. Never invent evidence or say a check passed when it was not run.
6. Produce the compact packet below. Include only paths and context needed by the destination.
7. Apply the readiness test: without the old transcript, can the destination state the goal, current phase, verified state, material decision rationale, unique next action, prerequisite access path, and authorization boundary? If not, expand the packet or declare the missing item as a blocker before rotating.
8. If rotation is warranted, follow the actor-specific flow in [references/context-rotation.md](references/context-rotation.md). A main agent moves to a fresh main chat when the interface supports it; a subagent always returns to the main agent, which verifies the packet before spawning a replacement.

## Handoff Packet

```markdown
# Handoff

## Continuity decision
- Actor: main agent or subagent
- Decision: `CONTINUE`, `CHECKPOINT`, or `ROTATE`
- Trigger signals:
- Phase exiting and phase entering:
- Predecessor and intended successor:

## Objective and acceptance criteria
- Goal:
- Done means:

## Scope
- In scope:
- Out of scope:

## Workspace identity
- Workspace root:
- Repository/worktree:
- Branch and commit:
- Dirty state:

## Current verified state
- Completed:
- Partially completed:
- Not started:

## Changed files
- `path`: purpose and relevant state

## Decisions and constraints
- User decisions:
- Technical decisions:
- Assumptions still requiring confirmation:

## Decision lineage
- Material decision:
- Evidence or trigger:
- Why this path:
- Rejected alternatives and why:

## Verification evidence
- `command`: result
- Not run or not verified:

## Failed or rejected paths
- Approach: observed failure or reason rejected

## Risks and blockers
- Risk/blocker:

## Continuation prerequisites and authorization
- Non-secret dependency and locator:
- Secret or capability purpose, safe locator/materializer, and verified availability (never the value):
- External state dependency:
- Authorized action, cap, consumed amount, and remaining allowance:
- User or approval action required if unavailable:

## Agent and model plan
- Main agent: role, recommended model/effort, and why
- Subagent:
  - Task and acceptance criteria:
  - Minimal context or files:
  - Model/effort:
  - Read-only or exact write scope:
  - Required verification/evidence:
  - Required `Subagent Handoff` return:
  - Ordering and whether the main agent must wait:
- Parallelism or ordering:
- Escalate or fall back only if:

## Subagent handoffs
- Agent/thread and delegated scope:
- Status: `COMPLETE`, `PARTIAL`, `BLOCKED`, or `STOPPED`
- Returned handoff or safe local reference:
- Parent verification and integration state:

## Unique next action
- One concrete action the destination should perform next:

## Destination validation sentinel
- Reopen/check:
- Run:
- Expected observable result:
```

Omit empty optional lines, but never omit the continuity decision, objective, acceptance criteria, workspace identity, verification status, material decision lineage, continuation prerequisites, authorization boundary, agent and model plan, unique next action, or validation sentinel.

## Consume a Handoff

1. Treat the packet as a claim to verify, not trusted state.
2. Confirm that the declared predecessor, successor, phase transition, and rotation reason still match the task. Downgrade to `CHECKPOINT` or stop if rotation was unnecessary or the packet is stale.
3. Confirm the workspace root and, when applicable, the repository, worktree, branch, commit, and dirty state.
4. Reopen the critical files and compare their actual contents with the packet.
5. Run the destination validation sentinel before writing. If it is unsafe or unavailable, explain what remains unverified.
6. Before writing, issue a compact continuity receipt: restate the objective, current phase, material decision rationale, verified state, unique next action, prerequisite access path, authorization boundary, and any unknowns. Do not ask the user to restate information already available in the packet or its cited artifacts.
7. Report material discrepancies or missing prerequisites and stop if they invalidate the acceptance criteria, permissions, or proposed next action. For a missing secret, use only the recorded safe retrieval path; never request that its value be pasted into chat.
8. Re-evaluate the agent and model plan against the actual remaining work. For non-trivial separable work, delegate bounded tasks to explicitly selected lower-cost subagents before consuming the main chat with large scans or routine implementation.
9. Wait for required subagents and collect a `Subagent Handoff` from each. Inspect their artifacts and evidence, reconcile conflicting packets, and integrate only verified results. The main agent retains acceptance responsibility.
10. If the packet is consistent, continue from the unique next action. Do not replay completed work or import unrelated history.

## Review and Safety Boundaries

- Review observable artifacts: requirements, plan, files, diff, commands, tests, logs, and results. Never request or claim access to hidden chain-of-thought.
- Do not include secrets, credentials, private tokens, or large raw logs in the packet. Point to a safe local artifact when necessary.
- A handoff does not expand write scope or authorize publishing, deployment, deletion, payment, or other external or irreversible actions.
- Keep one active writer per directory or worktree. Stop the previous writer before the destination begins writing.
- Subagents consume their own tokens and tool work. Use them to reduce expensive main-agent work when the task is meaningfully delegable, not to manufacture parallelism for tiny tasks.
- Do not treat a subagent thread as disposable context. Preserve its verified state through a compact handoff before replacement, escalation, or closure whenever practical.
- Never allow the predecessor and successor to write the same directory concurrently during rotation.
- Use a read-only reviewer for substantial or ambiguous handoffs when requested or permitted by applicable instructions; ordinary handoffs do not require a review ceremony.
