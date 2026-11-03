---
title: Your credentials
parent: User guide
nav_order: 2
---

# Your credentials

Home → **My Credentials** lists everything you hold.

{% include shot.html src="credentials.png" alt="My Credentials: filter pills All, #Money and #Travel, a sort menu and four credentials with their status" caption="The list: icon, name, issuer and a status line for each credential." %}

## The list

- Each row shows the credential's name (or your own **alias**), who issued it and who vouches for that issuer, and a status: **Valid**, **Expires in N days**, or **Expired**.
- **Search credentials** (at the bottom) matches name, alias, type, issuer, tags and the values inside the credentials (a name or a licence number, say).
- The **pills** under the title filter by tag; **All** clears the filter.
- **Sort** orders the list **A–Z**, **Z–A** or **Recent**.
- **View card layout →** swaps the rows for larger cards; **← View list layout** swaps back. The wallet remembers your choice.

### What "expires soon" means

A credential is **Valid** until 30 days before its end date. From then on it reads **Expires in N days** (shown in amber), and after the end date **Expired** (in red). Either way it appears under the **bell** on Home and in Notifications; see [Activity]({% link user-guide/activity.md %}). The wallet doesn't delete expired credentials for you.

## One credential

Tap a credential to open it.

{% include shot.html src="credential-detail.png" alt="A driving licence: the alias, a tag, the information it contains and the issuer details" caption="Your labels, the information inside, and the details of who issued it." %}

| Section | What it shows |
|---|---|
| **Your labels** | An **alias** (your own name for the credential, up to 40 characters, saved as you type) and **tags**. Both stay on this iPhone; the issuer and verifiers never see them. |
| **Your information** | Everything the credential contains, in plain labels (**Given name**, **Date of birth**, **Over 18**…). |
| **Details** | The **issuer**, whether it is **Verified** (and by which trust list), **Valid from** and **Valid until**, and when the wallet **Received** it. |
| **Activity** | The latest events for this credential, with **Show all activity** for the rest. |

When a credential is expiring or expired, a banner at the top says so, with the end date.

{% include shot.html src="credential-expiring.png" alt="A Personal ID credential with a banner: Expires in 23 days, valid until Nov 26, 2026" caption="An expiring credential. The banner is amber; for an expired one it is red." %}

### Tags

Tap **Add tag** and type a name. Tags show up as pills on the list. To remove a tag from one credential, tap the **×** on it. To remove a tag from **every** credential at once, use **Settings → Manage Tags**; the credentials stay.

## Deleting a credential

**Delete credential** (bottom of the detail screen) asks you to confirm. It **permanently removes the credential and its key from this iPhone**. The issuer isn't told, and nothing can restore it: you would need the issuer to issue it again. The deletion is recorded in your [Activity]({% link user-guide/activity.md %}).

## Developer mode

With **Developer mode** on (Settings → Advanced), the detail screen also shows the credential's **format** (`SD-JWT VC` or mdoc), its **type**, the namespace of mdoc claims, and raw claim identifiers instead of friendly labels. It changes what the wallet shows, not what it does.
