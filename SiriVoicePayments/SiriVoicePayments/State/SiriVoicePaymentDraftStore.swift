//
//  SiriVoicePaymentDraftStore.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation
import Combine

final class SiriVoicePaymentDraftStore: ObservableObject {
    static let shared = SiriVoicePaymentDraftStore()

    @Published var currentDraft: SiriVoicePaymentDraft?

    private init() { }

    func clear() {
        currentDraft = nil
    }
}
