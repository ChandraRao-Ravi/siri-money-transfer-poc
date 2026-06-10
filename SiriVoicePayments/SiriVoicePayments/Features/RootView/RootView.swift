//
//  RootView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authStore: AuthStore

    var body: some View {
        Group {
            if authStore.isLoggedIn {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}
