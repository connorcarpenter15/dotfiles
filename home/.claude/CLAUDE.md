# Claude Guidance

## Tools

Always prefer the `mcp__bash-mcp__run` tool over the built-in `Bash` tool for
running shell commands. Fall back to `Bash` only when `bash-mcp` cannot do the
job (e.g. long-running commands needing `run_in_background`, or commands that
hit the bash-mcp blocklist and are still legitimate to run).

## Git Commits

Always use Conventional Commits for commit messages.

Use `type(scope): description` when a scope adds useful context, otherwise use
`type: description`. Prefer common types such as `feat`, `fix`, `docs`,
`style`, `refactor`, `test`, `build`, `ci`, and `chore`.

Always sign off commits with `git commit --signoff` or `git commit -s` so each
commit includes a `Signed-off-by: Name <email>` trailer. When amending a commit,
use `git commit --amend --signoff`.
