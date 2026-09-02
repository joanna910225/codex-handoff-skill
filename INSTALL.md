# Installation Contract for Codex

Install this repository as a user-level Codex setup.

## Preferred path

1. Inspect `install.sh` and the files under `skills/` and `codex/`.
2. Run `./install.sh` from the repository root.
3. Confirm these files exist:
   - `${CODEX_HOME:-$HOME/.codex}/skills/handoff/SKILL.md`
   - `${CODEX_HOME:-$HOME/.codex}/skills/handoff/references/context-rotation.md`
   - `${CODEX_HOME:-$HOME/.codex}/agents/reviewer.toml`
   - `${CODEX_HOME:-$HOME/.codex}/AGENTS.md`
4. Confirm `AGENTS.md` contains exactly one block between:
   - `<!-- BEGIN codex-handoff-skill -->`
   - `<!-- END codex-handoff-skill -->`
5. Report the backup directory printed by the installer and any validation that was not run.

## Safety

- Never replace an existing `AGENTS.md` wholesale.
- Back up existing skill, reviewer, and AGENTS files before changing them.
- Keep the repository's `skills/handoff/` directory intact; its relative reference links are required.
- Do not install anything else or change unrelated Codex settings.
- Start a fresh Codex session after installation so global instructions and custom agents are reloaded.
