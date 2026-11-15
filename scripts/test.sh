#!/usr/bin/env bash
# Installs Formula/cfgaudit.rb from a local copy of this tap, runs its test
# block and checks that the installed binary is the formula's version.
set -euo pipefail

formula=Formula/cfgaudit.rb
if [ ! -f "$formula" ]; then
  echo "no formula yet: scripts/update.sh writes it"
  exit 0
fi
version=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$formula")
[ -n "$version" ] || { echo "no version in $formula" >&2; exit 1; }

tap="$(brew --repository)/Library/Taps/cfgaudit/homebrew-tap"
rm -rf "$tap"
mkdir -p "$tap"
cp -R Formula "$tap/"
brew style cfgaudit/tap/cfgaudit
brew install cfgaudit/tap/cfgaudit
brew test cfgaudit/tap/cfgaudit
got=$(cfgaudit --version)
echo "$got"
[ "$got" = "cfgaudit $version" ] || { echo "installed '$got', the formula says $version" >&2; exit 1; }
