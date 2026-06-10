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

    @State private var resolvedPayee: Payee?
    @State private var showPayeeNotFound = false
    @State private var isProcessing = false
    @State private var didSucceed = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Confirm transfer")
                        .font(.title.bold())
                    Text("Prepared from Siri / Shortcuts")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    row(title: "Payee alias", value: draft.payeeAlias)
                    
                    if let payee = resolvedPayee {
                        row(title: "Payee name", value: payee.name)
                        row(title: "Account / UPI", value: payee.accountRef)
                    } else {
                        row(title: "Payee", value: "Not found")
                            .foregroundStyle(.red)
                    }
                    
                    row(title: "Amount", value: amountString(draft.amount))
                    row(title: "Current balance", value: amountString(fromDecimal: accountStore.balance))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                if showPayeeNotFound {
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
                
                Button {
                    Task { await handleConfirm() }
                } label: {
                    HStack {
                        if isProcessing {
                            ProgressView()
                        } else {
                            Text("Confirm and transfer")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(resolvedPayee == nil ? Color.gray : Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(resolvedPayee == nil || isProcessing)
                
                Button("Cancel") {
                    draftStore.clear()
                }
                .foregroundStyle(.red)
                
                if didSucceed {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.green)
                        
                        Text("Payment simulated")
                            .font(.headline)
                        
                        Text("This POC updated your mock balance and recent transactions. A real app would also call the backend and PSP here.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Back to Home") {
                            draftStore.clear()
                        }
                        .padding(.top, 4)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(32)
                }
            }
            .navigationTitle("Voice payment")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if isProcessing {
                        ProgressView()
                    } else {
                        Button {
                            draftStore.clear()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            .onAppear {
                resolvePayee()
            }
        }
    }

    private func resolvePayee() {
        resolvedPayee = payeeStore.find(byAlias: draft.payeeAlias)
        showPayeeNotFound = resolvedPayee == nil
    }

    private func handleConfirm() async {
        guard let payee = resolvedPayee else { return }
        isProcessing = true
        didSucceed = false

        // 1. Optional biometric gate
        if authStore.biometricsEnabled {
            let ok = await authStore.tryBiometricLogin()
            if !ok {
                isProcessing = false
                // You could show a toast / error text here if you like
                return
            }
        }

        // 2. Simulate processing delay
        try? await Task.sleep(nanoseconds: 800_000_000)

        let amountDecimal = Decimal(draft.amount)
        accountStore.applyDebit(amount: amountDecimal, alias: payee.alias, description: "Voice payment")

        isProcessing = false
        didSucceed = true

        // 3. Auto-dismiss after a short delay
        Task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            draftStore.clear()
        }
    }

    private func row(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }

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
