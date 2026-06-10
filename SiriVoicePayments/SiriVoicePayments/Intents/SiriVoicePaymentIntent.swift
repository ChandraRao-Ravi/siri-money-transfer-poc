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

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .invalidAmount:
            return "Amount must be greater than zero."
        case .limitExceeded:
            return "For this demo, the maximum allowed amount is ₹5000."
        }
    }
}

struct SiriVoicePaymentIntent: AppIntent {
    static var title: LocalizedStringResource = "Send Money"
    static var description = IntentDescription("Prepare a transfer to a saved beneficiary.")
    static var openAppWhenRun: Bool = true

    @Parameter(
        title: "Recipient",
        requestValueDialog: IntentDialog("Who would you like to pay?")
    )
    var recipient: BeneficiaryEntity

    // Keep this as Double so it satisfies _IntentValue conformance safely
    @Parameter(
        title: "Amount",
        requestValueDialog: IntentDialog("How much would you like to send?")
    )
    var amountToSent: Int

    // To this:
    static var parameterSummary: some ParameterSummary {
        Summary("Send Money") {
            \.$recipient
            \.$amountToSent
        }
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard amountToSent > 0 else {
            throw SiriVoicePaymentError.invalidAmount
        }

        guard amountToSent <= 5000 else {
            throw SiriVoicePaymentError.limitExceeded
        }

        let amount = Double(amountToSent)
        let roundedAmount = (amount * 100).rounded() / 100

        await MainActor.run {
            SiriVoicePaymentDraftStore.shared.currentDraft = SiriVoicePaymentDraft(
                beneficiaryID: recipient.id,
                beneficiaryName: recipient.name,
                upiID: recipient.upiID,
                amount: roundedAmount
            )
        }

        return .result(
            dialog: IntentDialog("Prepared payment of ₹\(Int(roundedAmount)) for \(recipient.name). Please confirm in the app.")
        )
    }
}
