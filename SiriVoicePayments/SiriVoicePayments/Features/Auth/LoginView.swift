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
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.black, Color(.systemIndigo).opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                // Mark & title
                VStack(spacing: 8) {
                    Image(systemName: "indianrupeesign.circle.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(.white)

                    Text("SiriVoicePayments")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }

                // Card
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Secure login")
                            .font(.headline)

                        TextField("User ID", text: $userId)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .keyboardType(.asciiCapable)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        SecureField("PIN", text: $pin)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
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
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.teal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(isLoading)

                    Toggle("Use Face ID next time", isOn: $biometricsToggle)
                        .onChange(of: biometricsToggle) {
                            authStore.enableBiometrics(biometricsToggle)
                        }

                    if authStore.biometricsEnabled {
                        Button {
                            Task { _ = await authStore.tryBiometricLogin() }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "faceid")
                                Text("Unlock with Face ID")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: 420)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)

                Spacer(minLength: 16)
            }
            .padding(.horizontal, 24)
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
