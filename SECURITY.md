# Security policy

This repository is the Homebrew tap for [cfgaudit](https://github.com/cfgaudit/cfgaudit). Report a security problem in it, or in cfgaudit itself, as described in [cfgaudit's security policy](https://github.com/cfgaudit/cfgaudit/blob/main/SECURITY.md): through a [private vulnerability report](https://github.com/cfgaudit/cfgaudit/security/advisories/new), not a public issue.

That includes a cask that points to an archive outside cfgaudit's GitHub releases, or a checksum that does not match the release's `checksums.txt`.

The cask is written only by cfgaudit's release workflow (GoReleaser). Every archive it names carries a build provenance attestation from that workflow; [Verifying a release](https://github.com/cfgaudit/cfgaudit/blob/main/docs/verifying-releases.md) shows how to check it.
