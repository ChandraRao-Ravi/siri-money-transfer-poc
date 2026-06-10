//
//  KeychainService.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation

struct KeychainService {
    private let sessionKey = "svp_session_user"

    func hasValidSession() -> Bool {
        UserDefaults.standard.string(forKey: sessionKey) != nil
    }

    func storeSession(userId: String) {
        UserDefaults.standard.set(userId, forKey: sessionKey)
    }

    func clearSession() {
        UserDefaults.standard.removeObject(forKey: sessionKey)
    }
}
