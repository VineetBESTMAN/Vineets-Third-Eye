# Vineet's Third Eye — repository workflow

## Standalone repository

Repository: <https://github.com/VineetBESTMAN/Vineets-Third-Eye>

The display name is **Vineet's Third Eye**. GitHub's URL uses `Vineets-Third-Eye` because repository names cannot contain spaces or apostrophes. It was created as an independent public repository, not using GitHub's fork operation.

The new `main` begins at `613e3e7754e2a0b221a422250ee26b9632c61bda` with a fresh initial commit containing the existing application. All 3,308 tracked files matched the prior working copy at import. Old upstream commits and previous fork PRs are not part of the new Git history; changes and PRs made here start now. The original source derives from Bilawal Sidhu's God's Eye View, including local Windows fixes and the personalized branding. Its license and asset notices are retained.

## Branches, commits and PRs

- `main`: the stable/default branch.
- `feat/<topic>`: a new feature.
- `fix/<topic>`: a correction.
- `chore/<topic>` or `docs/<topic>`: maintenance and documentation.

Each task gets a real branch, meaningful commits, and a PR into `main`. Continue related work on the same branch and PR. Include a concise description, checks actually run, and screenshots when a visual change needs them. Keep the PR open for review until a merge is requested.

The repository allows **merge commits**, with squash and rebase merging disabled. Branches are retained after merging. This preserves the commit sequence and merge relationship in GitHub's commit/PR views and network graph. Repository settings do not create fictional past development history.

```powershell
git switch main
git pull --ff-only origin main
git switch -c feat/descriptive-change
# Make and verify the change.
git add <specific-files>
git commit -m "Describe the completed change"
git push -u origin feat/descriptive-change
gh pr create --base main --head feat/descriptive-change
```

Use the PR description template and `AGENTS.md` for future work. CI runs on PRs and pushes to `main`; a submitted run is not a passing run until GitHub reports its result.

`main` is protected: PRs must be up to date and pass `Node 24.22.2`, `Node 26.x`, `Street Level browser gate`, and `Windows onboarding`, supplied by GitHub Actions. Required reviewer approvals are set to zero by the owner's choice so Vineet can review and merge his own PRs manually. Authors cannot submit approving reviews on their own PRs; manual review followed by Merge is the solo workflow. Administrators are included, and force pushes and deletion are blocked. Automated work must leave PRs open until the user explicitly requests merging.

## Local setup and backup

The local directory remains `F:\OSINT project\gods-eye-view`, so launchers, dependencies and the running server continue to use the same location. `origin` points only to the new standalone repository. There is no `upstream` remote in this fresh Git history.

The entire previous `.git` directory is preserved at:

`F:\OSINT project\repository-backups\gods-eye-view-git-before-standalone`

A file manifest is stored alongside it as `gods-eye-view-tracked-files.txt`. This backup contains the old local Git history and configuration; it is outside the new repository and is not uploaded. GitHub issues, PR comments and settings are separate from Git and are not included in that backup.

`LOCAL-VALIDATION.md` describes the earlier setup tests and therefore retains old commit IDs as historical evidence. Those IDs belong to the backed-up history, not the new `main`. Import future upstream fixes deliberately on a task branch; do not attempt a normal merge of unrelated histories.
