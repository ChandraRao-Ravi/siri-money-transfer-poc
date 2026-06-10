//
//  SiriVoicePaymentDraft.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation

struct SiriVoicePaymentDraft: Identifiable, Hashable {
    let id = UUID()
    let beneficiaryID: String
    let beneficiaryName: String
    let upiID: String
    let amount: Double
}
