---
title: Receiving a credential
parent: User guide
nav_order: 1
---

# Receiving a credential

An issuer gives you a **credential offer**: a QR code, or a link that starts with `openid-credential-offer://`. Either starts the same flow.

## Start it

| You have | Do this |
|---|---|
| A QR code on another screen or on paper | Home → **Scan QR code**, and hold the code in the frame. |
| A link on this iPhone (a web page, an email, a message) | Tap it. iOS opens the wallet. |
| A link you copied | Home → **Paste link** → **Paste from clipboard**, then **Continue**. |
| Only the issuer's address (`https://…`) | Paste it the same way. See [Signing in at the issuer](#signing-in-at-the-issuer). |

{% include shot.html src="paste.png" alt="The Paste link screen with a field and Paste from clipboard" caption="Paste link. The wallet works out whether it is an offer, a request or an issuer address." %}

If the iPhone can't scan (no camera, or camera access is off), the scanner says so and offers **Paste link instead**.

While the wallet talks to the issuer you'll see **Contacting the issuer…**, then **Receiving credential…**.

## Entering a transaction code

Some issuers protect an offer with a one-time code that they send you **separately** (by SMS or email, for example). The wallet asks for it, with the issuer's own hint.

{% include shot.html src="tx-code.png" alt="The Transaction code screen asking for a 6-digit code" caption="The code comes from the issuer, not from the QR code." %}

## Signing in at the issuer

If you gave the wallet an issuer's address instead of an offer, the wallet reads which credentials that issuer offers. When there is more than one, you choose.

{% include shot.html src="issuer-choice.png" alt="Choose a credential: Personal ID and Mobile driving licence" caption="Choose which credential to sign in for." %}

The wallet then opens the issuer's sign-in page in a **private browser sheet** (it shares no cookies with Safari and keeps none). Sign in as the issuer instructs. The sign-in must finish within **5 minutes**.

## Read the consent screen

Before anything is stored, the wallet shows what you would receive. Nothing is added until you tap **Add credential**.

{% include shot.html src="offer-consent.png" alt="Add this credential?: Verified issuer, the issuer's address, the validity and the information it contains" caption="Who issued it, how long it is valid, and every piece of information it contains." %}

- The banner at the top says whether the **issuer is verified**. **Verified issuer · VCu sandbox** means the credential chains to a root this wallet trusts. **Unverified issuer** means the signature and contents are fine, but the root is unknown to the wallet; the screen shows whose it is. Add it only if you expected it. See [Trust and security]({{ '/user-guide/trust-and-security.html' | relative_url }}).
- **Information it contains** lists everything the issuer put in the credential.
- **Add credential** asks for Face ID or your passcode, then stores the credential. **Decline offer** discards it and tells the issuer you declined.

{% include shot.html src="outcome-added.png" alt="Credential added, with View credential and Back to Home" caption="Done. View the credential, or go back to Home." %}

## When it doesn't work

The wallet says what happened, in plain words, on its own screen. Common cases:

| You see | Meaning | What to do |
|---|---|---|
| **This link has expired** | The issuer no longer accepts the offer. Offers are single use and short-lived (10 minutes on the VCu sandbox). | Ask the issuer for a new one. |
| **You're offline** | The step needs a connection. | Reconnect and try again before the link expires. |
| **That isn't a credential offer link** / **That isn't a link this wallet can use** | The link isn't an offer, a request or an issuer address. | Paste a credential offer, a presentation request or an issuer `https` address. |
| **Credential not added**: failed verification | The wallet checked the credential and it didn't pass. Nothing was stored. | Tell the issuer. |
| **Credential not added**: bound to a different key | The issuer tied the credential to a key that isn't this wallet's, so it could never be shown. Nothing was stored. | Tell the issuer. |
| **Sign-in at the issuer didn't complete** | The sign-in was cancelled or timed out. | Start again. |

{% include shot.html src="outcome-offline.png" alt="A result screen explaining that the wallet couldn't reach the issuer" caption="Failures get their own screen, with a plain-language reason." %}

{: .note }
> Turn on **Developer mode** in Settings to see the technical detail behind an error, such as the HTTP status the issuer returned.
