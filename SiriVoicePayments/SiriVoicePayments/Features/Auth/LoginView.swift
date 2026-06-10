//
//  LoginView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authStore: AuthStore

    @State private var userId: String = ""
    @State private var pin: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var biometricsToggle = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 8) {
                    Text("SiriVoicePayments")
                        .font(.largeTitle.bold())
                    Text("Secure login")
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 16) {
                    TextField("User ID", text: $userId)
                        .keyboardType(.asciiCapable)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    SecureField("PIN", text: $pin)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Button {
                    Task { await handleLogin() }
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(isLoading)

                Toggle("Use Face ID next time", isOn: $biometricsToggle)
                    .onChange(of: biometricsToggle) { newValue in
                        authStore.enableBiometrics(newValue)
                    }

                if authStore.biometricsEnabled {
                    Button {
                        Task { _ = await authStore.tryBiometricLogin() }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "faceid")
                            Text("Unlock with Face ID")
                        }
                    }
                    .disabled(authStore.isCheckingBiometrics)
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            biometricsToggle = authStore.biometricsEnabled
        }
    }

    private func handleLogin() async {
        errorMessage = nil
        isLoading = true
        let ok = await authStore.login(userId: userId, pin: pin)
        isLoading = false

        if !ok {
            errorMessage = "Invalid credentials"
        }
    }
}
