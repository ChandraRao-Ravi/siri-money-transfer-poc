//
//  ConfirmSiriVoicePaymentView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct ConfirmSiriVoicePaymentView: View {
    let draft: SiriVoicePaymentDraft
    @EnvironmentObject var draftStore: SiriVoicePaymentDraftStore
    @State private var didSend = false

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Confirm payment")
                    .font(.title.bold())
                Text("Review the transfer prepared by Siri")
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 12) {
                row(title: "Recipient", value: draft.beneficiaryName)
                row(title: "UPI ID", value: draft.upiID)
                row(title: "Amount", value: currencyString(draft.amount))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Button {
                didSend = true
            } label: {
                Text("Confirm and continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Button("Cancel") {
                draftStore.clear()
            }
            .foregroundStyle(.red)

            if didSend {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.green)
                    Text("POC success")
                        .font(.headline)
                    Text("In a real app, this is where you would launch biometric auth or the PSP / UPI confirmation step.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 12)
            }

            Spacer()
        }
        .padding()
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

    private func currencyString(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.locale = Locale(identifier: "en_IN")
        return formatter.string(from: NSNumber(value: amount)) ?? "₹\(amount)"
    }
}
