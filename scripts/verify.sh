#!/usr/bin/env bash
# Checks every archive Casks/cfgaudit.rb names: its SHA-256 matches the cask
# and the release's checksums.txt, and its build provenance comes from
# cfgaudit's release build workflow. Needs gh with GH_TOKEN set.
set -euo pipefail

cask=Casks/cfgaudit.rb
version=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")
[ -n "$version" ] || { echo "no version in $cask" >&2; exit 1; }
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

gh release download "v$version" -R cfgaudit/cfgaudit -p checksums.txt -D "$workdir"
gh attestation verify "$workdir/checksums.txt" -R cfgaudit/cfgaudit \
  --signer-workflow cfgaudit/cfgaudit/.github/workflows/build-release.yml > /dev/null

# The cask lists sha256 and url in pairs, sha256 first.
pairs=$(awk '/^ *sha256 "/ { gsub(/"/, "", $2); sha = $2 } /^ *url "/ { gsub(/"/, "", $2); print sha, $2 }' "$cask")
[ -n "$pairs" ] || { echo "no url/sha256 pairs in $cask" >&2; exit 1; }
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
  [ "$actual" = "$sha" ] || { echo "$file: SHA-256 $actual, the cask says $sha" >&2; exit 1; }
  grep -qx "$sha  $file" "$workdir/checksums.txt" || { echo "$file: not in checksums.txt with $sha" >&2; exit 1; }
  gh attestation verify "$workdir/$file" -R cfgaudit/cfgaudit \
    --signer-workflow cfgaudit/cfgaudit/.github/workflows/build-release.yml > /dev/null
  echo "ok $file"
  n=$((n + 1))
done <<< "$pairs"
echo "verified $n archives of v$version"
