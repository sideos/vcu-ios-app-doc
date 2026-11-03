---
title: Home
layout: home
nav_order: 1
description: A native iPhone wallet that receives credentials from issuers and shares them with verifiers, only when you agree.
---

<div class="hero">
  <img class="hero-logo" src="{{ '/assets/img/sideos-logo-dark.png' | relative_url }}" alt="sideos" width="167" height="34">
  <h1 class="hero-title">Your credentials, on your iPhone. Shared only when you agree.</h1>
  <p class="hero-lead">The iOS Wallet receives digital IDs, licences and other credentials from an issuer, keeps them on your device, and shows a verifier only what you approve.</p>
  <p class="hero-actions">
    <a class="btn btn-primary" href="{{ '/getting-started.html' | relative_url }}">Get started</a>
    <a class="btn btn-outline-light" href="{{ '/user-guide/' | relative_url }}">Read the user guide</a>
  </p>
  <div class="hero-phones">
    <img src="{{ '/assets/img/share-consent.png' | relative_url }}" alt="The consent screen: Share information?, who is asking, and the one item that will be shared" loading="lazy">
    <img src="{{ '/assets/img/home.png' | relative_url }}" alt="The Home screen: Scan QR code, Paste link, My Credentials and Activity" loading="lazy">
    <img src="{{ '/assets/img/credentials.png' | relative_url }}" alt="My Credentials: four credentials with their status" loading="lazy">
  </div>
</div>

{: .warning }
> **This is a test and reference wallet, not a production wallet.** It exists so issuers and verifiers have a real iPhone holder to test against. It is distributed through TestFlight, and it trusts the VCu sandbox's issuer and verifier roots only (see [Trust and security]({{ '/user-guide/trust-and-security.html' | relative_url }})).

These pages describe **build {{ site.wallet_build }}**. Every screenshot was captured from that build with made-up data. They show the **sideos branding**, which is imported into the app; the app's own name is **VCu Wallet** (see [Branding]({{ '/branding.html' | relative_url }})).

## What you can do

<div class="features">
  <div class="feature"><h3><span class="dot purple"></span>Receive</h3><p>Scan a QR code or open a link from an issuer. See who issued it and what it contains before you add it.</p></div>
  <div class="feature"><h3><span class="dot green"></span>Hold</h3><p>Keep IDs, licences and cards on the iPhone. Give them names and tags, see when they expire.</p></div>
  <div class="feature"><h3><span class="dot magenta"></span>Share</h3><p>See who is asking and exactly what would be shared. Share, decline, or block the requester.</p></div>
  <div class="feature"><h3><span class="dot black"></span>Pay</h3><p>Approve a payment request: the amount and payee are shown, and your approval signs those exact details.</p></div>
</div>

## How it works

<ol class="steps">
  <li><strong>An issuer offers a credential.</strong> You scan its QR code, tap its link, or paste it. The wallet checks the issuer and shows what you would receive.</li>
  <li><strong>You add it.</strong> Face ID or your passcode confirms. The credential is stored on the iPhone and tied to a key that never leaves it.</li>
  <li><strong>A verifier asks to see it.</strong> The wallet shows who is asking and which information they want. Nothing is sent until you tap Share.</li>
</ol>

## Where to start

| I want to… | Go to |
|---|---|
| Install the app and open it for the first time | [Getting started]({{ '/getting-started.html' | relative_url }}) |
| Add, view and share credentials | [User guide]({{ '/user-guide/' | relative_url }}) |
| Make my issuer or verifier work with this wallet | [Integration guide]({{ '/integration.html' | relative_url }}) |
| Change the wallet's name, colours or logo | [Branding]({{ '/branding.html' | relative_url }}) |

## What it supports

| | |
|---|---|
| **Issuance** | [OpenID4VCI 1.0](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html): pre-authorized code (with an optional transaction code) and the authorization code flow with a sign-in step. |
| **Presentation** | [OpenID4VP 1.0](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html) with DCQL queries, by link or QR code. |
| **Credential formats** | SD-JWT VC (`dc+sd-jwt`) and ISO mdoc (`mso_mdoc`). |
| **Safari** | A website can ask for an mDL through Safari's [Digital Credentials API](https://www.w3.org/TR/digital-credentials/) (`org-iso-mdoc`); the wallet appears as a document provider. |
| **Payments** | Transaction data (TS12) on SD-JWT credentials: the amount and payee are shown and bound to your approval. |
| **Device** | iPhone with iOS 26 or later. The key is held in the Secure Enclave. |
| **Languages** | English and German. |

{: .note }
> Specification versions and status change. The links above point to the current published text; check them before relying on a detail.
