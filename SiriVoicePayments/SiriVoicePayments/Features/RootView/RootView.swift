//
//  RootView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var draftStore: ShortcutDraftStore

    var body: some View {
        Group {
            if !authStore.isLoggedIn {
                LoginView()
            } else if let draft = draftStore.currentDraft {
                ShortcutTransferConfirmView(draft: draft)
            } else {
                ContentView()
            }
        }
    }
}
