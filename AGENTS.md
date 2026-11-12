# Vineet's Third Eye repository workflow

This is the standalone repository `VineetBESTMAN/Vineets-Third-Eye`.

- Inspect the current branch and working tree before changing files; preserve user work.
- Implement each new task on a descriptive `feat/`, `fix/`, `chore/`, or `docs/` branch based on current `main`. Reuse the task's existing branch when continuing that same task.
- Commit meaningful changes with clear messages, push the task branch, and open or update its pull request against `main`. Do not push future changes directly to `main`.
- PR descriptions must explain the behavior or documentation change, relevant verification results, and material limitations. Never claim unrun checks passed.
- Keep the PR open for review unless the user requests merging it. Use merge commits when merging so the original branch commits remain visible. Retain branches unless the user asks to delete them.
- Use `scripts/windows.ps1` for the workspace-local supported Node runtime. Run checks appropriate to the change; do not run every expensive browser suite for documentation-only changes.
- Preserve the original MIT copyright and all third-party data/asset notices. This is a personalized derivative, not a claim that the inherited code was newly authored here.
- Never commit credentials, `.env` files, dependency installations, generated build output, or raw logs.

See `REPOSITORY-WORKFLOW.md` for provenance, the migration record and Git commands.
