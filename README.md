# Codex Handoff Skill

A personal Codex setup for context-health checks, phase handoffs, and safe main-agent/subagent rotation.

It includes:

- the `handoff` skill and all of its references;
- a read-only `reviewer` subagent profile;
- an idempotent global `AGENTS.md` fragment;
- a small installer that backs up existing files before updating them.

## Give this repository to Codex

Paste this into a Codex chat:

```text
Install the Codex handoff setup from this repository:
https://github.com/joanna910225/codex-handoff-skill

Read INSTALL.md, preserve my existing AGENTS.md, install the skill and reviewer,
and verify the resulting files. Do not overwrite unbacked configuration.
```

## Install only the skill

```text
$skill-installer install the handoff skill from
https://github.com/joanna910225/codex-handoff-skill/tree/main/skills/handoff
```

The skill-only route does not install the global continuity rules or the reviewer profile.

## Manual one-command install

```bash
git clone git@github.com:joanna910225/codex-handoff-skill.git
cd codex-handoff-skill
./install.sh
```

Open a fresh Codex session after installation. If the skill is not selected automatically, invoke it with `$handoff`.
