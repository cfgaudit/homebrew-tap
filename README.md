# Homebrew tap for cfgaudit

[cfgaudit](https://github.com/cfgaudit/cfgaudit) is a static security auditor for AI coding agent configuration: Claude Code, MCP servers, Cursor, Codex, Copilot, Gemini CLI and more.

```sh
brew install cfgaudit/tap/cfgaudit
```

It works on macOS and Linux, on Intel and ARM. `brew upgrade --cask cfgaudit` gets new releases.

## How the cask is updated

[`Casks/cfgaudit.rb`](Casks/cfgaudit.rb) is written by GoReleaser in cfgaudit's release workflow, once per release. It names the release archives and their SHA-256 checksums, and Homebrew checks each download against that checksum. Do not edit the cask by hand: the next release overwrites it. Change the `homebrew_casks` section of cfgaudit's [`.goreleaser.yml`](https://github.com/cfgaudit/cfgaudit/blob/main/.goreleaser.yml) instead.

To check that an archive was built by cfgaudit's release workflow, verify its build provenance as described in [Verifying a release](https://github.com/cfgaudit/cfgaudit/blob/main/docs/verifying-releases.md):

```sh
gh attestation verify cfgaudit_<version>_darwin_arm64.tar.gz -R cfgaudit/cfgaudit
```

## Problems and contributions

Problems with cfgaudit or with this cask go to [cfgaudit/cfgaudit](https://github.com/cfgaudit/cfgaudit/issues). How to contribute is in cfgaudit's [CONTRIBUTING.md](https://github.com/cfgaudit/cfgaudit/blob/main/CONTRIBUTING.md). Security problems go through private reporting, see [SECURITY.md](SECURITY.md).

## License

Apache-2.0, like cfgaudit. See [LICENSE](LICENSE).
