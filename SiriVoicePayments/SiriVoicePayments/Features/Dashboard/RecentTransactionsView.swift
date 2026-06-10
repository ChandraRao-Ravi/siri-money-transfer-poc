//
//  RecentTransactionsView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct RecentTransactionsView: View {
    @EnvironmentObject var accountStore: AccountStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(accountStore.recentTransactions.prefix(5)) { txn in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(txn.payeeAlias)
                                .font(.headline)
                            Spacer()
                            Text(formattedAmount(txn.amount, direction: txn.direction))
                                .font(.subheadline)
                                .foregroundStyle(txn.direction == .debit ? .red : .green)
                        }

                        Text(txn.description)
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        Text(formattedDate(txn.date))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Last 5 transactions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }

    private func formattedAmount(_ amount: Decimal, direction: Transaction.Direction) -> String {
        let number = NSDecimalNumber(decimal: amount)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.locale = Locale(identifier: "en_IN")
        let sign = direction == .debit ? "-" : "+"
        return "\(sign)\(formatter.string(from: number) ?? "₹\(number)")"
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
