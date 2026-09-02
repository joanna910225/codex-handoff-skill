# Model and Subagent Routing

Use this reference when a handoff includes non-trivial remaining work. The goal is not maximum parallelism; it is to keep an expensive main chat from performing work that a cheaper, well-scoped subagent can complete and verify.

## Core Allocation

- **Main agent:** owns scope, decomposition, permissions, cross-task decisions, integration, acceptance, and the final response. It should not absorb broad reading, repetitive transformations, routine implementation, or test triage merely because it already has the conversation.
- **Subagents:** own bounded capabilities with explicit inputs, outputs, file scope, and verification. Give each only the context it needs rather than the full conversation.
- **Reviewer:** stays read-only and challenges observable artifacts. It does not take over implementation or inspect hidden reasoning.

## Model Matrix

Choose the least expensive model that can reliably satisfy the task, then use the lowest sufficient reasoning effort.

| Work | Preferred model and effort | Examples |
| --- | --- | --- |
| Clear, narrow, repeatable, or high-volume | `gpt-5.6-luna`, `low` or `medium` | inventory, extraction, classification, formatting, focused searches, simple test or log triage |
| Everyday work requiring solid reasoning or tool use | `gpt-5.6-terra`, `medium` | read-heavy exploration, large-file review, ordinary implementation, document processing, targeted debugging |
| Independent review or edge-case analysis | `gpt-5.6-terra`, `high` | checkpoint review, correctness review, test-gap analysis, assumption checking |
| Ambiguous, cross-cutting, high-risk, or unusually difficult | `gpt-5.6-sol`, `high` or above only as justified | architecture, hard root-cause analysis, security-sensitive reasoning, consequential integration decisions |

Model names can change. If one is unavailable, preserve the role: Luna means fast and low-cost, Terra means balanced everyday work, and Sol means maximum depth. Record the replacement model and rationale in the agent plan. Do not silently fall back from a cheaper requested role to the main agent's expensive model; if only a materially more expensive or less capable replacement is available, revise the routing plan before spawning and surface the tradeoff.

## Main-Agent Choice

- If the current main chat is already using Sol, keep it as the coordinator. Delegate substantial bounded work to Luna or Terra instead of continuing all execution in the main context.
- For a fresh destination thread, recommend Terra with medium reasoning for ordinary implementation and coordination. Recommend Sol only when ambiguity, risk, or integration depth genuinely requires it.
- A Luna main thread is suitable only when the complete remaining task is clear, narrow, and repeatable.
- Max or Ultra is not a default. Use it only for the hardest work or when meaningful parallel decomposition justifies it.

## Delegation Test

Delegate when all of the following are true:

1. The task can be expressed as one bounded capability or question.
2. The subagent can return a concrete artifact, evidence set, diff, or structured finding.
3. The main agent can verify the result without replaying the whole investigation.
4. Delegation is expected to save expensive main-agent context or wall-clock time.

Keep the work in one agent when it is trivial, inseparable from the next decision, or likely to cost more in coordination than execution.

## Spawn Contract

For every subagent, specify:

- task and acceptance criteria;
- minimal files or context;
- explicit model and reasoning effort;
- read-only or exact write scope;
- required commands or evidence;
- the required `Subagent Handoff` return contract from [subagent-handoff.md](subagent-handoff.md);
- whether the main agent must wait before continuing.

If a subagent may spawn child agents, explicitly require it to pass the same contract downstream and consolidate the child handoffs. Parallelize only independent work. Keep one writer per directory or worktree. The main agent must inspect diffs, test evidence, and unresolved assumptions rather than accepting summaries at face value.

## Escalation

Start with the lowest plausible tier. Escalate Luna to Terra, or Terra to Sol, only after one well-scoped attempt exposes a capability gap, ambiguity, or risk that the higher tier addresses. Do not repeat the same failed approach under a more expensive model without new evidence or a changed plan.
