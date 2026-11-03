// Demo data and screen routing for the documentation screenshots.
//
// NOT part of the app. tools/screenshots/capture.sh copies this file into a
// temporary copy of the app's source tree, patches a few lines to call it, and
// builds that copy for the simulator. Everything here is made up: the holder
// "Ada Lovelace", the issuers and the verifiers do not exist.
//
// Launch arguments (all optional):
//   -seedDemo            create the demo credentials and activity (once)
//   -brandFile <path>    import a brand config (as Settings → Branding does)
//   -noBrand             reset to the default etonec branding
//   -route a,b,c         push these screens (see `routes`)
//   -open <link>         handle an openid4vp:// or openid-credential-offer:// link, as if scanned
//   -show <state>        open a modal: offer | txcode | choice | added | shared | paid | offline | refused
import Foundation
import VCuCore

@MainActor
enum ScreenshotSeed {
    static let pidId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    static let mdlId = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
    static let cardId = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
    static let eventId = UUID(uuidString: "00000000-0000-0000-0000-0000000000e1")!

    private static var args: [String] { ProcessInfo.processInfo.arguments }
    private static func value(after flag: String) -> String? {
        guard let index = args.firstIndex(of: flag), index + 1 < args.count else { return nil }
        return args[index + 1]
    }

    static var routes: [Route] {
        (value(after: "-route") ?? "").split(separator: ",").compactMap { name in
            switch name {
            case "credentials": .credentials
            case "detail": .credential(mdlId)
            case "detail-pid": .credential(pidId)
            case "detail-card": .credential(cardId)
            case "history": .history(mdlId)
            case "activity": .activity(party: nil)
            case "event": .event(eventId)
            case "notifications": .notifications
            case "settings": .settings
            case "privacy": .privacy
            case "security": .security
            case "requesters": .requesters
            case "branding": .branding
            case "tags": .tags
            case "developer": .developer
            case "scan": .scan
            case "paste": .paste
            default: nil
            }
        }
    }

    /// Before the model loads: brand, lock setting and demo data.
    static func prepare() async {
        if let path = value(after: "-brandFile"), let data = FileManager.default.contents(atPath: path),
           let (brand, _) = try? Brand.importing(data) { Brand.current = brand }
        if args.contains("-noBrand") { Brand.reset() }
        guard args.contains("-seedDemo"), let store = try? CredentialStore.live() else { return }
        if ((try? await store.all()) ?? []).isEmpty == false { return }

        let issuer = "https://issuer.example.org/oid4vci/demo"
        let now = Date.now, day: TimeInterval = 86_400
        let credentials = [
            StoredCredential(id: pidId, format: .sdJwtVc, type: "urn:eudi:pid:1", issuer: issuer, raw: Data(),
                claims: ["": ["given_name": "Ada", "family_name": "Lovelace", "birth_date": "1990-12-10", "age_over_18": "true",
                              "nationality": "DE"]],
                trust: .trusted(anchorSet: "VCu sandbox"), validFrom: now - 7 * day, validUntil: now + 23 * day,
                receivedAt: now - 7 * day, displayName: "Personal ID"),
            StoredCredential(id: mdlId, format: .msoMdoc, type: "org.iso.18013.5.1.mDL", issuer: issuer, raw: Data(),
                claims: ["org.iso.18013.5.1": ["given_name": "Ada", "family_name": "Lovelace", "birth_date": "1990-12-10",
                                               "age_over_18": "true", "issuing_country": "DE", "driving_privileges": "[B, BE]"]],
                trust: .trusted(anchorSet: "VCu sandbox"), validFrom: now - 7 * day, validUntil: now + 200 * day,
                receivedAt: now - 7 * day, displayName: "Mobile driving licence"),
            StoredCredential(id: cardId, format: .sdJwtVc, type: "urn:vcu:payment:1", issuer: "https://bank.example.org", raw: Data(),
                claims: ["": ["account_holder": "Ada Lovelace", "iban": "DE00 1234 0000 0000 0042"]],
                trust: .trusted(anchorSet: "VCu sandbox"), validFrom: now - 30 * day, validUntil: now + 700 * day,
                receivedAt: now - 30 * day, displayName: "Demo bank account"),
            StoredCredential(format: .sdJwtVc, type: "urn:vcu:loyalty:1", issuer: "https://club.example.net", raw: Data(),
                claims: ["": ["member_name": "Ada Lovelace", "tier": "Gold"]],
                trust: .untrustedRoot(subject: "Example CA", subjectKeyIdentifier: nil), validFrom: nil, validUntil: now - 2 * day,
                receivedAt: now - 60 * day, displayName: "Café Aurora Club"),
        ]
        for credential in credentials { try? await store.save(credential) }
        try? await store.setAnnotations(CredentialAnnotations(alias: "Driving licence", tags: ["Travel"]), for: mdlId)
        try? await store.setAnnotations(CredentialAnnotations(alias: nil, tags: ["Money"]), for: cardId)

        // Who the wallet has shared with (Settings → Requesters). Hosts differ from the ones in the
        // consent screenshots so those still read as a first contact.
        if let registry = try? RequesterRegistry.live() {
            let tickets = RequesterKey.of(website: "tickets.example.com", verifiedOrganizationIdentifier: nil)
            try? await registry.recordShare(tickets, name: "tickets.example.com", at: now - 20 * day)
            try? await registry.recordShare(tickets, name: "tickets.example.com", at: now - 4 * day)
            try? await registry.recordShare(RequesterKey.of(website: "rentals.example.net", verifiedOrganizationIdentifier: nil),
                                            name: "rentals.example.net", at: now - 9 * day)
            try? await registry.setBlocked(true, RequesterKey.of(website: "unknown.example", verifiedOrganizationIdentifier: nil),
                                           name: "unknown.example", at: now - 3 * day)
        }

        guard let log = try? ActivityLog.live() else { return }
        try? await log.record(ActivityEvent(id: eventId, date: now - 3_600, kind: .shared, channel: .digitalCredentialsAPI,
            counterparty: "shop.example.com", counterpartyVerified: false, credentialId: mdlId,
            credentialName: "Mobile driving licence", disclosed: ["org.iso.18013.5.1/age_over_18"]))
        try? await log.record(ActivityEvent(date: now - 26 * 3_600, kind: .shared, channel: .openID4VP, counterparty: "pay.example.org",
            counterpartyVerified: true, credentialId: cardId, credentialName: "Demo bank account",
            disclosed: ["iban"], transactions: ["Payment · 12.80 EUR"]))
        try? await log.record(ActivityEvent(date: now - 7 * day, kind: .received, channel: .wallet, counterparty: "issuer.example.org",
            counterpartyVerified: true, credentialId: mdlId, credentialName: "Mobile driving licence"))
        try? await log.record(ActivityEvent(date: now - 3 * day, kind: .refused, channel: .openID4VP, counterparty: "unknown.example",
            counterpartyVerified: false, note: "Unsigned request, verified-only mode on"))
    }

    /// After the model loaded: open a modal state.
    static func apply(to model: WalletModel) {
        if let link = value(after: "-open") { Task { await model.handle(link) } }
        guard let state = value(after: "-show") else { return }
        switch state {
        case "offer":
            if let received = received(StoredCredential(format: .sdJwtVc, type: "urn:vcu:student:1", issuer: "https://university.example.edu",
                raw: Data(), claims: ["": ["given_name": "Ada", "family_name": "Lovelace", "student_id": "S-204117", "faculty": "Mathematics"]],
                trust: .trusted(anchorSet: "VCu sandbox"), validFrom: .now, validUntil: .now.addingTimeInterval(400 * 86_400),
                receivedAt: .now, displayName: "Student ID")) { model.pending = received }
        case "txcode":
            if let requirement = try? JSONDecoder().decode(CredentialOffer.TxCode.self,
                from: Data(#"{"input_mode":"numeric","length":6,"description":"Enter the code you received from the issuer"}"#.utf8)) {
                model.txCodeRequest = .init(offerURI: "openid-credential-offer://?credential_offer_uri=https://issuer.example.org/offer/1", requirement: requirement)
            }
        case "choice":
            model.issuerChoice = .init(issuer: URL(string: "https://issuer.example.org")!, configurations: [
                (id: "pid", label: "urn:eudi:pid:1 · dc+sd-jwt"), (id: "mdl", label: "org.iso.18013.5.1.mDL · mdoc")])
        case "added": model.outcome = .credentialAdded(id: mdlId, name: "Mobile driving licence")
        case "shared": model.outcome = .shared(requester: "shop.example.com", fields: ["Age over 18"])
        case "paid": model.outcome = .paymentApproved(requester: "Café Aurora", summary: "12.80 EUR")
        case "offline":
            model.outcome = .failure(.init(kind: .offline, message: "The wallet couldn't reach the issuer. Check your connection and try again.",
                                           technical: nil, route: nil))
        case "refused":
            model.outcome = .failure(.init(kind: .refused, message: "This request was refused because it isn't from a verified requester.",
                                           technical: nil, route: .requesters))
        default: break
        }
    }

    private static func received(_ credential: StoredCredential) -> ReceivedCredential? {
        guard let data = try? JSONEncoder().encode(credential),
              let object = try? JSONSerialization.jsonObject(with: data),
              let wrapped = try? JSONSerialization.data(withJSONObject: ["credential": object]) else { return nil }
        return try? JSONDecoder().decode(ReceivedCredential.self, from: wrapped)
    }
}
