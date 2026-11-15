#!/usr/bin/env bash
# Checks every archive Formula/cfgaudit.rb names: its SHA-256 matches the
# formula and the release's checksums.txt, and its build provenance comes from
# cfgaudit's release build workflow. Needs gh with GH_TOKEN set.
set -euo pipefail

formula=Formula/cfgaudit.rb
if [ ! -f "$formula" ]; then
  echo "no formula yet: scripts/update.sh writes it"
  exit 0
fi
version=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$formula")
[ -n "$version" ] || { echo "no version in $formula" >&2; exit 1; }
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

gh release download "v$version" -R cfgaudit/cfgaudit -p checksums.txt -D "$workdir"
gh attestation verify "$workdir/checksums.txt" -R cfgaudit/cfgaudit \
  --signer-workflow cfgaudit/cfgaudit/.github/workflows/build-release.yml > /dev/null

# The formula lists url and sha256 in pairs, url first.
pairs=$(awk '/^ *url "/ { gsub(/"/, "", $2); url = $2 } /^ *sha256 "/ { gsub(/"/, "", $2); print $2, url }' "$formula")
[ -n "$pairs" ] || { echo "no url/sha256 pairs in $formula" >&2; exit 1; }
n=0
while read -r sha url; do
  url=${url//'#{version}'/$version}
  case $url in
    "https://github.com/cfgaudit/cfgaudit/releases/download/v$version/"*) ;;
    *) echo "$url is not a cfgaudit v$version release asset" >&2; exit 1 ;;
  esac
  file=${url##*/}
  curl -fsSL -o "$workdir/$file" "$url"
  actual=$(sha256sum "$workdir/$file" | cut -d' ' -f1)
  [ "$actual" = "$sha" ] || { echo "$file: SHA-256 $actual, the formula says $sha" >&2; exit 1; }
  grep -qx "$sha  $file" "$workdir/checksums.txt" || { echo "$file: not in checksums.txt with $sha" >&2; exit 1; }
  gh attestation verify "$workdir/$file" -R cfgaudit/cfgaudit \
    --signer-workflow cfgaudit/cfgaudit/.github/workflows/build-release.yml > /dev/null
  echo "ok $file"
  n=$((n + 1))
done <<< "$pairs"
echo "verified $n archives of v$version"
