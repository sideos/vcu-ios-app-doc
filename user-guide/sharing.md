---
title: Sharing a credential
parent: User guide
nav_order: 3
---

# Sharing a credential

A **verifier** (a website, an app, a shop terminal's QR code) asks to see information from your credentials. The wallet never sends anything until you tap **Share**.

## How a request reaches the wallet

| The verifier shows | Do this |
|---|---|
| A QR code | Home → **Scan QR code**. |
| A button or link on this iPhone | Tap it; iOS opens the wallet (links start with `openid4vp://`). |
| A link you copied | Home → **Paste link**. |
| A request in Safari, for an mDL | Safari lists the wallet when it holds a matching document; see [Safari](#in-safari). |

While the wallet reads the request you'll see **Loading request…**.

## The consent screen

{% include shot.html src="share-consent.png" alt="Share information?: who is asking, a warning that the request is unsigned, and the one item that will be shared" caption="Who is asking, what would be shared, and your three choices." %}

Read it from the top.

### Who is asking?

The banner under the name says how far the wallet can vouch for the requester:

| Banner | Meaning |
|---|---|
| **Verified relying party: Acme · VCu sandbox** | The request is signed with an access certificate that chains to a trusted authority. The organisation name comes from that certificate. |
| **Verified website: shop.example.com (Web PKI)** | The request is signed with a certificate your iPhone trusts for that website. It proves the website, not who stands behind it. |
| **Signed by Acme, which this wallet doesn't recognise** | The signature is valid, but the issuer of the certificate isn't on a trust list the wallet knows. |
| **Unsigned request; responses go to shop.example.com** / **This website didn't identify itself** | Nobody vouches for the requester. The only thing you know is where the answer would be sent. Share only if you started this yourself. |

Below it, **You haven't shared with this requester before** appears on a first contact. A requester with a **registration certificate** may also show a registration banner. Registrations are checked; the sandbox's test registration is labelled **TEST registrar-verified registration (sandbox, not a real registration)**.

If the response will be **encrypted to the verifier**, the screen says so.

### Information to be shared

Every item is listed under the credential it comes from: **From Driving licence – Over 18: Yes**. That list is the whole disclosure: nothing else leaves the iPhone.

- **Requested but not in this credential** marks something the verifier asked for that the credential doesn't hold. The rest can still be shared.
- If **no credential** can answer, you get **No matching credential**, and the verifier is told there was no match.

### Your three choices

| Button | What happens |
|---|---|
| **Share information** | Asks for Face ID or your passcode, then signs and sends **only the listed items**. |
| **Decline request** | Sends nothing but a refusal (`access_denied`) to the verifier. Recorded as **Declined request**. |
| **Block this requester** | Declines, and refuses every later request from this requester **without asking**. Undo it in Settings → Requesters. |

### Afterwards

{% include shot.html src="outcome-shared.png" alt="Information shared: Age over 18 sent to shop.example.com" caption="Confirmation of what was sent and to whom." %}

The screen says what was sent and to whom. Some verifiers ask the wallet to send you back to their page or app when you're done; the wallet does so after Share or Decline. If the verifier doesn't, go back to it yourself. **View activity** opens the record of this share.

## Approving a payment

Some requests carry **transaction details**, such as a payment. The screen changes from **Share information?** to **Approve payment**.

{% include shot.html src="payment-consent.png" alt="Approve payment: Payment to Café Aurora, 12.80 EUR, the transaction details and the credential used" caption="The amount and payee come from the request; the credential that signs is shown under Paying with." %}

- The **amount** is shown large, with **Payment to** the payee, then **Transaction details** for every field of the request.
- **Paying with** shows which credential will be used and what it will disclose.
- **Approving signs these exact details with your device key.** The verifier gets proof that this wallet, on this iPhone, approved this amount to this payee. Approval always asks for Face ID or your passcode.
- **Approve 12.80 EUR** approves; **Decline payment** refuses; **Block this requester** works as above.

{% include shot.html src="outcome-paid.png" alt="Payment approved: 12.80 EUR approved for Café Aurora" caption="After approval." %}

{: .note }
> Transaction details are supported on **SD-JWT** credentials. An mdoc credential can't carry them, so the wallet won't answer such a request from one.

## In Safari

A website can ask for your mDL through Safari's **Digital Credentials API**. The wallet is a *document provider*: when the page asks, iOS shows its own picker, and if you choose VCu Wallet, a sheet from the wallet shows who is asking and what would be shared, with **Share** and **Don't share**.

- The wallet is offered only if it **holds a document of the requested type**, and only if **Settings → Privacy & Sharing → Let websites see which documents I hold** is on.
- Safari offers third-party wallets only the ISO mdoc protocol, so SD-JWT credentials can't be requested this way. Use a link or QR code for those.
- The sheet has a **Block website** option, like **Block this requester**.

## When a request is refused for you

| You see | Why |
|---|---|
| **Request refused** | Either you blocked this requester, or **Only share with verified relying parties** is on and the requester isn't verified. |
| **You blocked acme.example, so the request was refused** | Unblock it in Settings → Requesters if you want to hear from it again. |
| **No matching credential** | Nothing you hold can answer it. The verifier was told. |
| **The presentation request is invalid** / **This link has expired** | The request is malformed, or the verifier no longer accepts it. Ask for a new one. |
| **Identity check failed** | Face ID or the passcode didn't succeed. Nothing was sent. |

Refusals are recorded in your [Activity]({% link user-guide/activity.md %}).
