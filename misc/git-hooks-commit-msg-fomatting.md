## Update the git init hooks for commit-msg formatting rule

The hook copies the template to `.git/hooks/` when `git init` is executed.

### Preparation

Check the template dir.
```
git config --global init.templateDir

# example of return if git-secrets already set
~/.git-templates/git-secrets
```

When the template directory is already set, we cannot create a template with the same name. So copy the directory and override it.
```
cp ~/.git-templates/git-secrets ~/.git-templates/my-hooks
git config --global init.templateDir ~/.git-templates/my-hooks
```

Edit template.
```
code ~/.git-templates/my-hooks/hooks/commit-msg
```
### Code

`~/.git-templates/my-hooks/hooks/commit-msg`

Note that the 2nd line is the setting of the original git secrets settings.

```bash
#!/usr/bin bash
git secrets --commit_msg_hook -- "$@"

# This script is a Git hook that checks commit messages for specific formatting rules.
echo -e "\033[37;1m📝 Running Git Hooks: commit-msg\033[0m"

# Read commit message
MSG="$(cat "$1")"
readonly MSG
code=0

# Define allowed prefixes
readonly CORRECT_PREFIXES=("feat" "fix" "docs" "style" "refactor" "pref" "test" "chore")
# Build regex string like: "feat: |fix: |..."
prefixes="$(IFS="|"; echo "${CORRECT_PREFIXES[*]/%/: }")"

check_prefix() {
  echo -en " - Checking for valid prefix: "
  if ! echo "$MSG" | grep -Eq "$prefixes"; then
    echo -e "\033[31;22mNG"
    echo -e "================================================================"
    echo -e "Commit message must start with a valid prefix."
    echo -e ""
    echo -e "Allowed prefixes:"
    echo -e "  ${CORRECT_PREFIXES[*]/%/: }"
    echo -e "================================================================\033[0m\n"
    return 1
  else
    echo -e "\033[32;22mOK\033[0m"
    return 0
  fi
}

check_trailing_period() {
  echo -en " - Checking for trailing period: "
  if echo "$MSG" | grep -Eq '\.\s*$'; then
    echo -e "\033[31;22mNG"
    echo -e "================================================================"
    echo -e "Commit message must not end with a period."
    echo -e "================================================================\033[0m\n"
    return 1
  else
    echo -e "\033[32;22mOK\033[0m"
    return 0
  fi
}

# Run checks
check_prefix || code=1
check_trailing_period || code=1

# Final result
if [ "$code" -ne 0 ]; then
  echo ""
  echo -e "\033[31;1mGit Hooks: commit-msg: NG\033[0m\n\n"
fi

exit $code
```
