//
//  ShortcutDraftStore.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation
import Combine

@MainActor
final class ShortcutDraftStore: ObservableObject {
    static let shared = ShortcutDraftStore()

    @Published var currentDraft: IntentDraft?

    private init() {}

    func setDraft(payeeAlias: String, amount: Double, note: String? = nil) {
        currentDraft = IntentDraft(payeeAlias: payeeAlias, amount: amount, note: note)
    }

    func clear() {
        currentDraft = nil
    }
}
