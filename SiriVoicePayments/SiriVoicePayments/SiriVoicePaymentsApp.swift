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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(draftStore)
                .onAppear {
                    // Force the sync once the view hierarchy is active and registered
                    SiriVoicePaymentsShortcutsProvider.updateAppShortcutParameters()
                }
        }
    }
}
