#!/bin/bash

set -eu -o pipefail

currentDate=$(date '+%Y-%m-%d-%H.%M.%S')
screencapture -ci

# Full path
/opt/homebrew/bin/pngpaste "$HOME/Pictures/Screenshots/$currentDate.png"
