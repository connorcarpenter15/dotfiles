# Codex Guidance

## Git Commits

Always use Conventional Commits for commit messages.

Use `type(scope): description` when a scope adds useful context, otherwise use
`type: description`. Prefer common types such as `feat`, `fix`, `docs`,
`style`, `refactor`, `test`, `build`, `ci`, and `chore`.

Always sign off commits with `git commit --signoff` or `git commit -s` so each
commit includes a `Signed-off-by: Name <email>` trailer. When amending a commit,
use `git commit --amend --signoff`.

## Git Publishing

When `main` allows direct commits and I am the repository's only contributor,
commit and push directly to `main`. Do not create a branch or pull request in
that situation.

## Git Branches

Never create a Git branch with the `codex/` prefix. Use a Conventional Commit
type as the branch prefix instead, such as `feat/`, `fix/`, `docs/`,
`refactor/`, `test/`, `build/`, `ci/`, or `chore/`.

## Pull Requests

Always use a Conventional Commit-style pull request title:
`type(scope): description` when a scope is useful, otherwise
`type: description`. Never include `codex` in a pull request title.

## Cluster Filesystem Safety

Never run `find`, recursive `grep`, `du`, or another recursive filesystem
traversal over `/home`, `/lustre`, or any other shared filesystem root from a
cluster frontend or login node. Read-only commands can still saturate a shared
NFS client and disrupt other users.

Run recursive searches on a compute node inside a scheduler allocation, and
scope them to a known user, project, or scratch directory. If no compute
allocation is available, use a non-recursive inventory mechanism or ask before
proceeding; do not fall back to a broad frontend-node scan.
