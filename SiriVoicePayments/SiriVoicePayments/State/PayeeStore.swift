//
//  PayeeStore.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class PayeeStore: ObservableObject {
    static let shared = PayeeStore()

    @Published private(set) var payees: [Payee] = []

    private let storageKey = "svp_payees"

    private init() {
        load()
        if payees.isEmpty {
            seedMock()
        }
    }

    func addPayee(name: String, alias: String, accountRef: String) {
        var trimmedAlias = alias.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedAlias.isEmpty {
            trimmedAlias = name
        }

        let payee = Payee(name: name, alias: trimmedAlias, accountRef: accountRef)
        payees.append(payee)
        persist()
    }

    func deletePayees(at offsets: IndexSet) {
        payees.remove(atOffsets: offsets)
        persist()
    }

    func updatePayee(_ payee: Payee) {
        guard let idx = payees.firstIndex(where: { $0.id == payee.id }) else { return }
        payees[idx] = payee
        persist()
    }

    func find(byAlias alias: String) -> Payee? {
        let trimmed = alias.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if let exact = payees.first(where: { $0.alias.lowercased() == trimmed }) {
            return exact
        }

        return payees.first { $0.alias.lowercased().contains(trimmed) || $0.name.lowercased().contains(trimmed) }
    }

    // MARK: - Persistence

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([Payee].self, from: data)
            payees = decoded
        } catch {
            payees = []
        }
    }

    private func persist() {
        do {
            let data = try JSONEncoder().encode(payees)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // For POC, silently ignore
        }
    }

    private func seedMock() {
        payees = [
            Payee(name: "Ramesh Kumar", alias: "House Owner", accountRef: "ramesh@upi"),
            Payee(name: "Papa", alias: "Papa", accountRef: "papa@upi"),
            Payee(name: "Electricity Board", alias: "Electricity", accountRef: "electricity@upi")
        ]
        persist()
    }
}
