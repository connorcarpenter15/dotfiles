# Codex Guidance

## Git Commits

Always use Conventional Commits for commit messages.

Use `type(scope): description` when a scope adds useful context, otherwise use
`type: description`. Prefer common types such as `feat`, `fix`, `docs`,
`style`, `refactor`, `test`, `build`, `ci`, and `chore`.

Always sign off commits with `git commit --signoff` or `git commit -s` so each
commit includes a `Signed-off-by: Name <email>` trailer. When amending a commit,
use `git commit --amend --signoff`.
