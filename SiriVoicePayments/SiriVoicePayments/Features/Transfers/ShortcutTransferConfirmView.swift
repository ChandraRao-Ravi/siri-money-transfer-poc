//
//  ShortcutTransferConfirmView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct ShortcutTransferConfirmView: View {
    let draft: IntentDraft

    @EnvironmentObject var draftStore: ShortcutDraftStore
    @EnvironmentObject var payeeStore: PayeeStore
    @EnvironmentObject var accountStore: AccountStore
    @EnvironmentObject var authStore: AuthStore
    @Environment(\.dismiss) private var dismiss

    @State private var resolvedPayee: Payee?
    @State private var showPayeeNotFound = false
    @State private var isProcessing = false
    @State private var didSucceed = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                VStack(spacing: 0) {
                    // Content
                    ScrollView {
                        VStack(spacing: 24) {
                            headerAmount

                            detailsCard

                            if showPayeeNotFound {
                                payeeNotFoundMessage
                            }

                            Text("You’ll review and confirm this payment in-app. No money moves without confirmation.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                    }

                    // Bottom actions
                    VStack(spacing: 12) {
                        Button {
                            Task { await handleConfirm() }
                        } label: {
                            Text("Confirm and transfer")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.cyan],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .disabled(resolvedPayee == nil || isProcessing)
                        .opacity(resolvedPayee == nil || isProcessing ? 0.5 : 1)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(.regularMaterial)
                }

                if isProcessing {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                    ProgressView("Processing…")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                if didSucceed {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    successOverlay
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        draftStore.clear()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .onAppear {
                resolvePayee()
            }
        }
    }

    // MARK: - Subviews

    private var headerAmount: some View {
        VStack(spacing: 4) {
            Text("Confirm transfer")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(amountString(draft.amount))
                .font(.system(size: 32, weight: .bold, design: .rounded))

            Text("to \(resolvedPayee?.alias ?? draft.payeeAlias)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let payee = resolvedPayee {
                Text("Recipient")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.teal.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(payee.alias.prefix(1)).uppercased())
                                .font(.headline)
                                .foregroundStyle(.teal)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(payee.alias)
                            .font(.headline)
                        Text(payee.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(payee.accountRef)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
            } else {
                Text("Recipient")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Not found")
                    .font(.headline)
                    .foregroundStyle(.red)
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Amount")
                    Spacer()
                    Text(amountString(draft.amount))
                        .fontWeight(.semibold)
                }

                HStack {
                    Text("Current balance")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(amountString(fromDecimal: accountStore.balance))
                        .foregroundStyle(.secondary)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var payeeNotFoundMessage: some View {
        VStack(spacing: 8) {
            Text("No saved payee matching this alias.")
                .font(.footnote)
                .foregroundStyle(.red)

            Text("Add a payee with alias “\(draft.payeeAlias)” in Manage Payees, then run this shortcut again.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var successOverlay: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)

            Text("Payment simulated")
                .font(.headline)

            Text("Your mock balance and recent transactions have been updated. A real app would also call the backend and PSP here.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Back to Home") {
                draftStore.clear()
                dismiss()
            }
            .padding(.top, 4)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(32)
    }

    // MARK: - Logic

    private func resolvePayee() {
        resolvedPayee = payeeStore.find(byAlias: draft.payeeAlias)
        showPayeeNotFound = resolvedPayee == nil
    }

    private func handleConfirm() async {
        guard let payee = resolvedPayee else { return }
        isProcessing = true
        didSucceed = false

        // Optional: biometric gate
        if authStore.biometricsEnabled {
            let ok = await authStore.tryBiometricLogin()
            if !ok {
                isProcessing = false
                return
            }
        }

        try? await Task.sleep(nanoseconds: 800_000_000)

        let amountDecimal = Decimal(draft.amount)
        accountStore.applyDebit(amount: amountDecimal, alias: payee.alias, description: "Voice payment")

        isProcessing = false
        didSucceed = true
    }

    // MARK: - Formatting

    private func amountString(_ amount: Double) -> String {
        let number = NSNumber(value: amount)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.locale = Locale(identifier: "en_IN")
        return formatter.string(from: number) ?? "₹\(amount)"
    }

    private func amountString(fromDecimal amount: Decimal) -> String {
        let number = NSDecimalNumber(decimal: amount)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.locale = Locale(identifier: "en_IN")
        return formatter.string(from: number) ?? "₹\(number)"
    }
}
