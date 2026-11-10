#!/usr/bin/env bash
# Installs Casks/cfgaudit.rb from a local copy of this tap and checks that the
# installed binary is the cask's version.
set -euo pipefail

version=$(sed -n 's/^  version "\(.*\)"$/\1/p' Casks/cfgaudit.rb)
[ -n "$version" ] || { echo "no version in Casks/cfgaudit.rb" >&2; exit 1; }

tap="$(brew --repository)/Library/Taps/cfgaudit/homebrew-tap"
rm -rf "$tap"
mkdir -p "$tap"
cp -R Casks "$tap/"
brew style cfgaudit/tap/cfgaudit
brew install --cask cfgaudit/tap/cfgaudit
got=$(cfgaudit --version)
echo "$got"
[ "$got" = "cfgaudit $version" ] || { echo "installed '$got', the cask says $version" >&2; exit 1; }
