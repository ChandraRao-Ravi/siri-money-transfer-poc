//
//  DashboardView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var accountStore: AccountStore

    @State private var showRecent = false
    @State private var showAccountDetails = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    balanceTile

                    quickActionsSection
                }
                .padding()
            }
            .navigationTitle("SiriVoicePayments")
        }
        .sheet(isPresented: $showRecent) {
            RecentTransactionsView()
                .environmentObject(accountStore)
        }
        .sheet(isPresented: $showAccountDetails) {
            AccountDetailsView()
                .environmentObject(accountStore)
        }
    }

    private var balanceTile: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current balance")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(formattedAmount(accountStore.balance))
                .font(.system(size: 32, weight: .bold, design: .rounded))

            HStack(spacing: 12) {
                Button {
                    showRecent = true
                } label: {
                    Label("Last 5 txns", systemImage: "list.bullet")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Button {
                    showAccountDetails = true
                } label: {
                    Label("Account details", systemImage: "info.circle")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .font(.footnote)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.teal.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick actions")
                .font(.headline)

            VStack(spacing: 12) {
                NavigationLink {
                    // Placeholder for manual send money flow
                    Text("Send Money (coming soon)")
                } label: {
                    actionRow(
                        title: "Send Money",
                        subtitle: "Start a manual transfer",
                        systemImage: "arrow.up.circle"
                    )
                }

                NavigationLink {
                    PayeeListView()
                } label: {
                    actionRow(
                        title: "Manage Payees",
                        subtitle: "View and add payees",
                        systemImage: "person.2"
                    )
                }
            }
        }
    }

    private func actionRow(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(Color.teal)
                .frame(width: 40, height: 40)
                .background(Color.teal.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func formattedAmount(_ amount: Decimal) -> String {
        let number = NSDecimalNumber(decimal: amount)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.locale = Locale(identifier: "en_IN")
        return formatter.string(from: number) ?? "₹\(number)"
    }
}
