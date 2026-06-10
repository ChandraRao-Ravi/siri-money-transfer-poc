//
//  AccountStore.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation
import Combine

@MainActor
final class AccountStore: ObservableObject {
    static let shared = AccountStore()

    @Published private(set) var balance: Decimal = 0
    @Published private(set) var recentTransactions: [Transaction] = []
    @Published private(set) var accountDetails: AccountDetails = .init(
        accountNumberMasked: "XXXX-XXXX-1234",
        accountType: "Savings",
        provider: "SiriVoice Bank"
    )

    private init() {
        loadMockData()
    }

    func loadMockData() {
        balance = 42_500

        recentTransactions = [
            Transaction(
                id: UUID(),
                date: Date().addingTimeInterval(-3600),
                amount: 10_000,
                direction: .debit,
                payeeAlias: "House Owner",
                description: "Monthly rent"
            ),
            Transaction(
                id: UUID(),
                date: Date().addingTimeInterval(-86400),
                amount: 2_500,
                direction: .debit,
                payeeAlias: "Groceries",
                description: "Supermarket"
            ),
            Transaction(
                id: UUID(),
                date: Date().addingTimeInterval(-2 * 86400),
                amount: 15_000,
                direction: .credit,
                payeeAlias: "Acme Corp",
                description: "Salary"
            ),
            Transaction(
                id: UUID(),
                date: Date().addingTimeInterval(-3 * 86400),
                amount: 800,
                direction: .debit,
                payeeAlias: "Mobile Recharge",
                description: "Prepaid top-up"
            ),
            Transaction(
                id: UUID(),
                date: Date().addingTimeInterval(-4 * 86400),
                amount: 3_000,
                direction: .debit,
                payeeAlias: "Dining",
                description: "Dinner out"
            )
        ]
    }
}
