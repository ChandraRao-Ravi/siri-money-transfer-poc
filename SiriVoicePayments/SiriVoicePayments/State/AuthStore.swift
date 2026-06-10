//
//  AuthStore.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation
import LocalAuthentication
import Combine

@MainActor
final class AuthStore: ObservableObject {
    static let shared = AuthStore()

    @Published private(set) var isLoggedIn = false
    @Published private(set) var biometricsEnabled = false
    @Published private(set) var isCheckingBiometrics = false

    private let keychain = KeychainService()
    private let biometricsFlagKey = "svp_biometrics_enabled"

    private init() {
        biometricsEnabled = UserDefaults.standard.bool(forKey: biometricsFlagKey)
        isLoggedIn = keychain.hasValidSession()
    }

    func login(userId: String, pin: String) async -> Bool {
        // TODO: later call backend; for now accept a fixed combo or any non-empty.
        guard !userId.isEmpty, !pin.isEmpty else { return false }

        // Simulate storing a session token
        keychain.storeSession(userId: userId)

        isLoggedIn = true
        return true
    }

    func enableBiometrics(_ enabled: Bool) {
        biometricsEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: biometricsFlagKey)
    }

    func tryBiometricLogin() async -> Bool {
        guard biometricsEnabled else { return false }

        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return false
        }

        isCheckingBiometrics = true
        defer { isCheckingBiometrics = false }

        let reason = "Unlock SiriVoicePayments"

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            if success, keychain.hasValidSession() {
                isLoggedIn = true
                return true
            }
        } catch let error {
            print(error.localizedDescription)
            return false
        }

        return false
    }

    func logout() {
        keychain.clearSession()
        isLoggedIn = false
    }
}
