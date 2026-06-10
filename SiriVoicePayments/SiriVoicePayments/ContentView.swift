//
//  ContentView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var draftStore: SiriVoicePaymentDraftStore

    var body: some View {
        NavigationStack {
            Group {
                if let draft = draftStore.currentDraft {
                    ConfirmSiriVoicePaymentView(draft: draft)
                } else {
                    SiriVoicePaymentsHomeView()
                }
            }
            .navigationTitle("SiriVoicePayments")
        }
    }
}
