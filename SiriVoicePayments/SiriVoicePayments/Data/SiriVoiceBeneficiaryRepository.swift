//
//  SiriVoiceBeneficiaryRepository.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation

// Mark the entire struct as @MainActor to protect its static and instance properties
@MainActor
struct SiriVoiceBeneficiaryRepository: Sendable {
    static let shared = SiriVoiceBeneficiaryRepository()

    let all: [Beneficiary] = [
        Beneficiary(id: "1", name: "Rajesh Sharma", upiID: "rajesh@oksbi", nickname: "Papa"),
        Beneficiary(id: "2", name: "Sunita Sharma", upiID: "sunita@okhdfcbank", nickname: "Mummy"),
        Beneficiary(id: "3", name: "Amit", upiID: "amit@okicici", nickname: nil)
    ]

    func find(byID id: String) -> Beneficiary? {
        all.first(where: { $0.id == id })
    }
}
