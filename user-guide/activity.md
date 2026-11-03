---
title: Activity
parent: User guide
nav_order: 4
---

# Activity

Everything the wallet does on your behalf is written down on this iPhone, so you can check it later. Home → **Activity**, or Settings → **Activity**.

{% include shot.html src="activity.png" alt="Activity: Shared, Payment approved, Request refused and Received, with dates" caption="Newest first. Each entry says what happened, with whom, and through which channel." %}

## What is recorded

| Entry | When |
|---|---|
| **Received** | You added a credential. |
| **Declined offer** | You declined one. |
| **Shared** | You shared information. A share that carried transaction details reads **Payment approved**. |
| **Declined request** | You declined a request. |
| **Request refused** | The wallet refused a request for you: a blocked requester, or an unverified one while **Only share with verified relying parties** is on. |
| **Requester blocked** | You blocked a requester from the consent screen. |
| **No matching credential** | Nothing you hold could answer a request; the verifier was told. |
| **Deleted** | You deleted a credential. |

Each entry shows **who** (the issuer or requester, with a small badge: green when verified, amber when not), the **channel** (**Wallet**, **Link or QR code**, or **Safari**), the credential, and the names of the items sent.

{: .note }
> The wallet records **which items** were shared (**Over 18**), not **their values**. For a payment it also keeps a short summary of the transaction. The history is stored on the iPhone and is readable only while it is unlocked, but anyone using your unlocked wallet can read it.

## One entry

Tap an entry for the details: **When** (to the second), **With**, **Trust** (**Verified** or **Not verified**), **Channel**, the **Credential**, **Information sent**, and any transaction details. **View credential** opens the credential involved.

{% include shot.html src="activity-event.png" alt="A Shared entry with when, who, trust, channel, the credential and the information sent" caption="An entry in full." %}

## Per credential and per requester

- A credential's own screen shows its latest three entries, and **Show all activity** for the rest.
- In Settings → **Requesters**, tap a requester to see only the entries with that party.

## Clearing it

**Clear** (top right) asks **Clear all activity?** and removes the history. **Stored credentials are not affected**, and requesters you blocked stay blocked. Settings → Requesters builds its **Received from** list from this history, so that list empties too.

## Notifications

The **bell** on Home lists credentials that have **expired** or **expire within 30 days**. Tap one to open it. When there is nothing to report, it says **You're all caught up**.

{% include shot.html src="notifications.png" alt="Notifications: Personal ID expires soon and Café Aurora Club has expired" caption="The bell. A dot on Home means something is due." %}

These are **in-app only**: the wallet sends no push notifications, so it can't alert you while closed.
