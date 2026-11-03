---
title: Trust and security
parent: User guide
nav_order: 6
---

# Trust and security

What the wallet protects, how it decides whom to trust, and where it stops.

{: .warning }
> This is a **test and reference wallet**. It trusts the **VCu sandbox's** roots only, and it has **no backup or recovery of credentials**. Don't put credentials in it that you can't have re-issued.

## Your key

Each credential is **bound to a key** created on this iPhone, in the **Secure Enclave**. A verifier can check that whoever presents the credential holds that key, so a copy of the credential alone is useless.

- The key **can't be exported**, copied to another device, or restored from a backup.
- Using it needs **Face ID or your passcode** (the key's access control requires your presence), and only while the iPhone is unlocked.
- That is why **sharing, adding credentials, payments and reset always ask** for Face ID or your passcode, whatever the lock setting.

## Your data

- Credentials, labels, requesters and activity are stored **on the iPhone only**. The wallet has no account and no cloud copy.
- The files use iOS **complete data protection**: they can only be read while the iPhone is unlocked.
- The wallet is **not** designed to keep data safe from someone who has unlocked your iPhone and the wallet; use **Lock wallet when opening** for that (see [Settings]({% link user-guide/settings.md %})).
- **Losing the iPhone loses the credentials.** The keys never leave the device, so credentials can't be restored from a backup or moved to a new iPhone. Ask the issuer to issue them again.
- Deleting a credential, or **Reset wallet**, removes it and its key for good.

## Whom the wallet trusts

### Issuers

When you add a credential, the wallet checks the issuer's signature on it, and then whether the issuer's certificate chains to a root it trusts.

| You see | Meaning |
|---|---|
| **Verified issuer · VCu sandbox** | Signature valid, and the chain ends at a root on the wallet's trust list. |
| **Unverified issuer** | Signature and contents are valid, but the chain ends at a root the wallet doesn't know. The consent screen names it. Adding it is your call. |

The wallet won't store a credential that **fails verification**, or one the issuer **bound to a different key**.

### Verifiers

The consent screen's banner tells you what the wallet can establish about a requester: a **verified relying party** (access certificate under a trusted authority), a **verified website** (Web PKI), a **signed request from an unknown authority**, or an **unsigned request**. See [Sharing a credential]({% link user-guide/sharing.md %}#who-is-asking). Turn on **Only share with verified relying parties** to refuse everything below the first level.

### The trust lists

The app ships with the VCu **sandbox** issuer root, access-CA root and registrar root. Credentials and requests under any other root are marked **unverified**. The trust lists are bundled in the app.

## What the verifier learns

- Only the **items you saw** on the consent screen. Both credential formats (SD-JWT VC and mdoc) support disclosing a subset, and the wallet sends only that.
- A verifier can't tell **which other credentials** you hold. In Safari, the wallet does tell iOS which **document types** it holds (not their contents), so iOS can offer it; switch that off in Settings → Privacy & Sharing.
- Responses to a verifier that provides a key are **encrypted to it**; the consent screen says when.
- Your **aliases, tags and activity** never leave the iPhone.

## Limits worth knowing

| Limit | Detail |
|---|---|
| Test trust only | Production issuers and verifiers aren't on the trust list. |
| One device | No backup, no sync, no recovery of credentials. |
| iPhone only | iOS 26 or later. |
| No presence signal | A web page can't tell whether the app is installed. |
