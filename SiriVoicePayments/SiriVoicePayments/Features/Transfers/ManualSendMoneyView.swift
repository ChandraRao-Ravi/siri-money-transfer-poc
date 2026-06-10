//
//  ManualSendMoneyView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct ManualSendMoneyView: View {
    @EnvironmentObject var payeeStore: PayeeStore
    @EnvironmentObject var accountStore: AccountStore
    @EnvironmentObject var draftStore: ShortcutDraftStore
    @EnvironmentObject var authStore: AuthStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPayee: Payee?
    @State private var amountText: String = ""
    @State private var showPayeePicker = false
    @State private var showError: String?
    @State private var showConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                VStack(spacing: 0) {
                    // Scrollable content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Title (use inline so it's part of content)
                            Text("Send Money")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .padding(.top, 8)

                            recipientCard
                            amountField

                            if let error = showError {
                                Text(error)
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                            }

                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                    }

                    // Bottom button area
                    VStack(spacing: 12) {
                        Button(action: {
                            validateAndPrepareDraft()
                        }) {
                            Text("Continue")
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
                        .disabled(selectedPayee == nil || amountText.isEmpty)
                        .opacity(selectedPayee == nil || amountText.isEmpty ? 0.5 : 1)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(.regularMaterial)
                }
            }
            .navigationBarTitleDisplayMode(.inline) // small back arrow only
        }
        .sheet(isPresented: $showPayeePicker) {
            PayeePickerView(selected: $selectedPayee)
                .environmentObject(payeeStore)
        }
        .sheet(isPresented: $showConfirm) {
            if let draft = draftStore.currentDraft {
                ShortcutTransferConfirmView(draft: draft)
                    .environmentObject(draftStore)
                    .environmentObject(payeeStore)
                    .environmentObject(accountStore)
                    .environmentObject(authStore)
            }
        }
    }

    // MARK: - Subviews

    private var recipientCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recipient")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                showPayeePicker = true
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recipient")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let payee = selectedPayee {
                            Text(payee.alias)
                                .font(.headline)
                            Text(payee.name)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("Choose payee")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.title3)
                        .foregroundStyle(.cyan)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .buttonStyle(.plain)
        }
    }

    private var amountField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Amount")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("Amount (INR)", text: $amountText)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }

    // MARK: - Logic

    private func validateAndPrepareDraft() {
        showError = nil

        guard let payee = selectedPayee else {
            showError = "Please choose a payee."
            return
        }

        guard let amountInt = Int(amountText), amountInt > 0 else {
            showError = "Enter a valid amount greater than zero."
            return
        }

        let amount = Double(amountInt)
        let rounded = (amount * 100).rounded() / 100

        draftStore.setDraft(payeeAlias: payee.alias, amount: rounded, note: nil)
        showConfirm = true
    }
}
