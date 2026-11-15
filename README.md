# Homebrew tap for cfgaudit

[cfgaudit](https://github.com/cfgaudit/cfgaudit) is a static security auditor for AI coding agent configuration: Claude Code, MCP servers, Cursor, Codex, Copilot, Gemini CLI and more.

```sh
brew install cfgaudit/tap/cfgaudit
```

It works on macOS and Linux, on Intel and ARM. `brew upgrade cfgaudit` gets new releases.

**Installed the cask before?** cfgaudit is a formula now (#6). Move once with:

```sh
brew uninstall --cask cfgaudit
brew install cfgaudit/tap/cfgaudit
```

## How the formula is updated

Nothing outside this repository writes to it. [`update.yml`](.github/workflows/update.yml) runs once a day and can be run by hand right after a release, with an optional tag. [`scripts/update.sh`](scripts/update.sh) then:

1. downloads the release's `checksums.txt` and its four archives;
2. checks each one against the build provenance of cfgaudit's release workflow, and each archive against `checksums.txt`;
3. writes [`Formula/cfgaudit.rb`](Formula/cfgaudit.rb) with those checksums.

The workflow installs the new formula and runs its test block, which checks the version and runs a scan that must report a finding. It then commits the formula with this repository's own token. Do not edit the formula by hand: the next update overwrites it. Change `scripts/update.sh` instead.

To check that an archive was built by cfgaudit's release workflow, verify its build provenance as described in [Verifying a release](https://github.com/cfgaudit/cfgaudit/blob/main/docs/verifying-releases.md):

```sh
gh attestation verify cfgaudit_<version>_darwin_arm64.tar.gz -R cfgaudit/cfgaudit
```

## Problems and contributions

Problems with cfgaudit or with this formula go to [cfgaudit/cfgaudit](https://github.com/cfgaudit/cfgaudit/issues). How to contribute is in cfgaudit's [CONTRIBUTING.md](https://github.com/cfgaudit/cfgaudit/blob/main/CONTRIBUTING.md). Security problems go through private reporting, see [SECURITY.md](SECURITY.md).

## License

Apache-2.0, like cfgaudit. See [LICENSE](LICENSE).
