//
//  SiriVoicePaymentsShortcutsProvider.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import AppIntents

struct SiriVoicePaymentsShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: SiriVoicePaymentIntent(),
                phrases: [
                    "Send money in \(.applicationName)",
                    "Transfer money in \(.applicationName)"
                ],
                shortTitle: "Send Money",
                systemImageName: "indianrupeesign.circle"
            )
        ]
    }
}
