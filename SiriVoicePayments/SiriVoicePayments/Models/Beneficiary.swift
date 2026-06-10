//
//  Beneficiary.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation

struct Beneficiary: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let name: String
    let upiID: String
    let nickname: String?
}
