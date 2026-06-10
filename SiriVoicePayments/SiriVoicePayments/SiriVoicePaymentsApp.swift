//
//  SiriVoicePaymentsApp.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI
import AppIntents

@main
struct SiriVoicePaymentsApp: App {
    @StateObject private var draftStore = SiriVoicePaymentDraftStore.shared
    @StateObject private var authStore = AuthStore.shared
    @StateObject private var accountStore = AccountStore.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(draftStore)
                .environmentObject(authStore)
                .environmentObject(accountStore)
                .onAppear {
                    SiriVoicePaymentsShortcutsProvider.updateAppShortcutParameters()
                }
        }
    }
}
