---
title: Settings
parent: User guide
nav_order: 5
---

# Settings

Home → the **gear**.

{% include shot.html src="settings.png" alt="Settings: Privacy and websites, Wallet, Appearance and Advanced groups, and Reset wallet" caption="Settings, top to bottom." %}

At the bottom you'll find the wallet's name, **build number** and iOS version. Quote them when you report a problem.

## Privacy & Sharing

{% include shot.html src="privacy.png" alt="Privacy and Sharing with two switches" caption="Two switches that control who can reach the wallet." %}

| Setting | What it does | Default |
|---|---|---|
| **Only share with verified relying parties** | "ARF mode": refuse any request that isn't signed with an access certificate from a trusted authority. Off, unsigned or unrecognised requests are allowed, with a warning on the consent screen. | Off, so test verifiers that don't sign still work |
| **Let websites see which documents I hold** | When on, iOS knows the **document types** in this wallet (not their contents) and offers VCu Wallet for matching requests in Safari. When off, the wallet isn't offered at all. | On |

## Requesters

Who you have dealt with.

{% include shot.html src="requesters.png" alt="Requesters: Shared with, Received from and Blocked" caption="Shared with, received from, and blocked." %}

- **Shared with**: requesters you have shared with, how many times, and since when. Press and hold one for **Block** or **Forget** (forget removes it from this list). Tap one to see its activity.
- **Received from**: the issuers your credentials came from.
- **Blocked**: requesters whose requests are refused automatically. **Unblock** lifts it.

## Activity

The same history as on Home. See [Activity]({% link user-guide/activity.md %}).

## Manage Tags

{% include shot.html src="tags.png" alt="Tags: #Money and #Travel, each used by one credential, with delete buttons" caption="Delete a tag here to remove it from every credential." %}

Lists every tag with the number of credentials that use it. The bin removes a tag **from every credential**; the credentials stay.

## Security & App Lock

{% include shot.html src="security.png" alt="Security and App Lock: Confirm sensitive actions with Face ID, and Lock wallet when opening" caption="Face ID is always required for sensitive actions; the lock is optional." %}

- **Confirm sensitive actions: Face ID.** Sharing, adding credentials, payments and resetting the wallet **always** ask for Face ID or your device passcode. This can't be switched off.
- **Lock wallet when opening.** Covers the wallet with a lock screen until Face ID or your passcode succeeds, on launch and every time you come back to the app. Off by default.

{% include shot.html src="lock.png" alt="Wallet locked, with an Unlock button" caption="The lock screen." %}

{: .note }
> If the iPhone has **no passcode**, there is nothing to lock with, so the wallet doesn't lock itself. Set a passcode in iOS Settings first.

## Branding

Name and colours; see [Branding]({% link branding.md %}). **Import brand from clipboard** applies a brand config you copied; **Reset branding** returns to the default.

## Developer mode

**Advanced → Developer mode** shows document types, claim identifiers and protocol names in the credential and activity screens, and the technical detail behind errors. It also adds a **Developer** page with the state of the Safari document provider (**Sync registrations with stored mDLs** forces a resync), the wallet's keys and the last presentation. It's meant for people testing issuers and verifiers; leave it off otherwise.

## Reset wallet

{: .warning }
> **Reset wallet** deletes **every credential and its keys** from this iPhone, for good. Issuers aren't told, and nothing can restore them. It asks you to confirm, then for Face ID or your passcode. **Activity history, settings and branding are kept.**
