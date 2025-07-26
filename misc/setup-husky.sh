#!/bin/bash
# This script sets up Husky and Commitlint.
# It initializes Husky, and configures the only commit-msg hook.

set -eo pipefail

npm install -D @commitlint/cli @commitlint/config-conventional
echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js

# Install husky
npm install --save-dev husky
npx husky init

# Set only commit-msg hook
cat << 'EOF' > .husky/commit-msg
npx --no -- commitlint --edit "$1"
EOF
chmod +x .husky/commit-msg

# Remove the default pre-commit hook
if [[ "$OSTYPE" == darwin* ]]; then
  sed -i '' '/npm test/d\\' .husky/pre-commit
else
  sed -i '/npm test/d\\' .husky/pre-commit
fi
