//
//  SiriVoicePaymentIntent.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import AppIntents
import Foundation

enum SiriVoicePaymentError: Error, CustomLocalizedStringResourceConvertible {
    case invalidAmount
    case limitExceeded
    case missingAlias

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .invalidAmount:
            return "Amount must be greater than zero."
        case .limitExceeded:
            return "For this demo, the maximum allowed amount is ₹5000."
        case .missingAlias:
            return "Please provide who you want to pay."

        }
    }
}

struct SiriVoicePaymentIntent: AppIntent {
    static var title: LocalizedStringResource = "Send Money"
    static var description = IntentDescription(
        "Prepare a transfer to a saved payee using their alias and amount."
    )
    static var openAppWhenRun: Bool = true

    @Parameter(
        title: "Payee alias",
        requestValueDialog: IntentDialog("Who would you like to pay?")
    )
    var payeeAlias: String

    @Parameter(
        title: "Amount",
        requestValueDialog: IntentDialog("How much would you like to send?")
    )
    var amountToSent: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Send Money") {
            \.$payeeAlias
            \.$amountToSent
        }
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let trimmedAlias = payeeAlias.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedAlias.isEmpty else {
            throw SiriVoicePaymentError.missingAlias
        }

        guard amountToSent > 0 else {
            throw SiriVoicePaymentError.invalidAmount
        }

        // Demo limit; tweak as needed
        guard amountToSent <= 500_000 else {
            throw SiriVoicePaymentError.limitExceeded
        }

        let amount = Double(amountToSent)
        let roundedAmount = (amount * 100).rounded() / 100

        await MainActor.run {
            ShortcutDraftStore.shared.setDraft(
                payeeAlias: trimmedAlias,
                amount: roundedAmount,
                note: nil
            )
        }

        let dialog = IntentDialog(
            "Preparing payment of ₹\(Int(roundedAmount)) for \(trimmedAlias) in SiriVoicePayments. Please confirm in the app."
        )

        return .result(dialog: dialog)
    }
}
