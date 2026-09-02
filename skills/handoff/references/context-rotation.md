# Context Health and Rotation

Use this gate throughout long work. It is an automatic continuity check, not a request for the user to notice context failure first.

## Evaluation Moments

Evaluate continuity:

- before entering a new phase such as research to implementation, implementation to verification, or verification to release;
- after a compaction event, context-limit warning, or heavy reliance on an earlier summary;
- after major user steering, changed acceptance criteria, ownership transfer, or model change;
- after a subagent handoff that leaves substantial continuation work;
- whenever forgetting or context drift appears.

## Signals

Treat any of these as strong signals:

- context was compacted and critical decisions or evidence are no longer directly recoverable;
- the agent cannot accurately restate the goal, acceptance criteria, current phase, changed-file ownership, verified evidence, and unique next action;
- accepted decisions are contradicted, completed work is repeated, or the wrong files, branch, or worktree are being used;
- the same facts or files are repeatedly rediscovered because earlier state was lost;
- continuing would require trusting an unverified summary rather than the workspace.

Treat these as weaker signals that become material when combined or at a phase boundary:

- the thread contains many obsolete alternatives or rejected approaches;
- the next phase needs a different model, permission boundary, tool surface, or writer;
- the next work is a coherent outcome that no longer benefits from the old transcript;
- available token or context indicators show sustained pressure even though no hard limit has been reached.

Do not use a fixed token percentage as the sole trigger. Rotate on observable reliability and phase coherence. One strong signal, or multiple weak signals at a phase boundary, normally warrants `ROTATE`.

## Decisions

- `CONTINUE`: the current agent can restate the six critical facts, the phase remains coherent, and no strong signal exists.
- `CHECKPOINT`: early drift or a phase boundary exists, but the same agent can continue after refreshing verified state.
- `ROTATE`: context reliability is degraded, the next phase is a different coherent unit, or a fresh owner/model will materially reduce risk or cost.

Record the decision and its evidence. Do not silently rotate or silently ignore a strong signal.

## Main-Agent Rotation

1. Stop new mutations at a safe boundary.
2. Request and collect handoffs from active subagents. Mark missing packets unverified.
3. Verify the workspace, changed files, branch/worktree state, and the most important evidence.
4. Produce the full main `Handoff` packet, including phase transition, agent/model plan, all unresolved subagent states, and a destination validation sentinel.
5. Release the old main agent's write ownership.
6. If the active interface provides fresh-chat creation, start a new main chat with only the packet and necessary file references. Do not copy the entire transcript.
7. If fresh-chat creation is unavailable, stop with the packet ready to paste and state that the user must open the new chat. Do not pretend a new main chat was created.
8. The new main agent validates the packet before writing, then decides which fresh subagents are needed.

Main-agent rotation is a sequential ownership transfer, not two main chats writing in parallel.

## Subagent Rotation

1. The old subagent stops at a safe boundary and returns a `Subagent Handoff` with `PARTIAL`, `BLOCKED`, or `STOPPED`; it may use `COMPLETE` when the phase itself finished but a new phase continues elsewhere.
2. The main agent inspects the packet, artifacts, diff, and verification evidence.
3. The main agent records accepted facts, rejects or marks unsupported claims, and closes or stops the old writer.
4. The main agent chooses the least expensive capable successor model and creates a fresh subagent with the verified packet, required files, exact write scope, validation sentinel, and return-handoff contract.
5. The fresh subagent confirms the actual workspace and sentinel before writing, then continues from the unique next action.

Do not let the old subagent directly appoint its successor or pass unverified state around the main agent. The chain of custody is always:

`old subagent → Subagent Handoff → main-agent verification → fresh subagent`

## Phase Boundaries

A new phase triggers an assessment, not an automatic rotation by itself. Rotate when the phase also changes one or more of:

- acceptance criteria or deliverable;
- model or reasoning needs;
- tools or permission boundary;
- directory/worktree ownership;
- dominant context, such that most prior history is now noise.

Otherwise record a checkpoint and continue in the same thread.
