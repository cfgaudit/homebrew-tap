# Security policy

This repository is the Homebrew tap for [cfgaudit](https://github.com/cfgaudit/cfgaudit). Report a security problem in it, or in cfgaudit itself, as described in [cfgaudit's security policy](https://github.com/cfgaudit/cfgaudit/blob/main/SECURITY.md): through a [private vulnerability report](https://github.com/cfgaudit/cfgaudit/security/advisories/new), not a public issue.

That includes a formula that points to an archive outside cfgaudit's GitHub releases, or a checksum that does not match the release's `checksums.txt`.

The formula is written only by this repository's [`update.yml`](.github/workflows/update.yml), after it has checked every archive against the build provenance attestation of cfgaudit's release workflow and the release's `checksums.txt`. No other repository has write access. [Verifying a release](https://github.com/cfgaudit/cfgaudit/blob/main/docs/verifying-releases.md) shows how to check an archive yourself.
