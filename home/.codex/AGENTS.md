# Codex Guidance

## Communication Preferences

- Be concise.
- Prefer bullet points over paragraphs.
- Prefer actionable items over narrative analysis.
- The user will redirect if the response is too verbose.
- Never hard-wrap Markdown. Write each paragraph and list item as one continuous line, relying on soft wrap; use newlines only to separate paragraphs, list items, headings, code fences, and tables.

## Git Commits

Always use Conventional Commits for commit messages.

Use `type(scope): description` when a scope adds useful context, otherwise use
`type: description`. Prefer common types such as `feat`, `fix`, `docs`,
`style`, `refactor`, `test`, `build`, `ci`, and `chore`.

Always sign off commits with `git commit --signoff` or `git commit -s` so each
commit includes a `Signed-off-by: Name <email>` trailer. When amending a commit,
use `git commit --amend --signoff`.

Never amend an existing commit or force-push a branch unless the user explicitly
asks for that history rewrite.

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

## DLCluster Storage Safety

Never read from, write to, mount, or create directories under
`/mnt/cifs/home/swdl-fw-infra`. That CIFS mount is reserved exclusively for the
DLFW GitLab HPC Runner; it is not user or benchmark scratch space.

Before writing persistent data on DLCluster, discover and verify an approved
per-user or project scratch path using the compute-session scratch-path tooling
and the `scratch-space` skill. Do not guess a shared path. Do not remove or
modify existing content under the reserved CIFS mount without explicit owner
authorization.
