//
//  BeneficiaryEntity.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import AppIntents

struct BeneficiaryEntity: AppEntity, Identifiable, Hashable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Beneficiary")
    static var defaultQuery = BeneficiaryQuery()

    let id: String
    let name: String
    let upiID: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: "\(upiID)"
        )
    }
}
