//
//  IntentDraft.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation

struct IntentDraft: Identifiable, Hashable {
    let id = UUID()
    let payeeAlias: String
    let amount: Double
    let note: String?
}
