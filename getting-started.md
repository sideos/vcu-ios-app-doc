---
title: Getting started
nav_order: 2
---

# Getting started

## Install

The app is called **VCu Wallet** and is distributed through **TestFlight**. It needs an iPhone with **iOS 26 or later** (it isn't built for iPad).

1. Install **TestFlight** from the App Store, if you don't have it.
2. Open the invitation link you were sent, and accept it in TestFlight.
3. Tap **Install** on VCu Wallet.

{: .note }
> TestFlight builds stop working after 90 days. When a new build is available, TestFlight offers the update; install it before the old one expires. Your credentials stay on the iPhone across updates. The wallet's version is shown at the bottom of **Settings** (name, build number and iOS version).

## First launch

The wallet opens on **Home**. There is no sign-up and no account: everything stays on this iPhone.

{% include shot.html src="home.png" alt="The Home screen with Scan QR code, Paste link, My Credentials and Activity" caption="Home. Scan or paste to add a credential or answer a request; open your credentials and your activity below." %}

- **Scan QR code** and **Paste link** are how everything starts, whether you are receiving a credential or answering a verifier. The wallet detects which it is.
- **My Credentials** lists what you hold. **Activity** lists everything received, shared and deleted.
- The **bell** (top right) shows a dot when a credential has expired or expires soon. The **gear** opens Settings.

### Permissions you will be asked for

| When | What | Why |
|---|---|---|
| First time you scan | **Camera** | To read QR codes. If you say no, you can still **Paste link**, and **Open Settings** from the scanner takes you to the switch. |
| Adding a credential, sharing, approving a payment, resetting | **Face ID** (or your passcode) | To confirm it is you. The wallet's signing key sits in the iPhone's Secure Enclave and can't be used without it. |

The wallet doesn't send you push notifications. The bell is an in-app list.

### Lock the wallet

Settings → **Security & App Lock** → **Lock wallet when opening** asks for Face ID or your passcode every time the wallet opens. It is off by default; see [Settings]({% link user-guide/settings.md %}).

{% include shot.html src="lock.png" alt="The lock screen with the sideos logo and an Unlock button" caption="With the lock on, the wallet opens to this screen." %}

## Next

- Put a credential in the wallet: [Receiving a credential]({% link user-guide/receiving.md %}).
- Show one to a verifier: [Sharing a credential]({% link user-guide/sharing.md %}).
