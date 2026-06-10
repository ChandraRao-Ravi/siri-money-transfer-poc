//
//  Payee.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation

struct Payee: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String        // Full name, e.g. Ramesh Kumar
    var alias: String       // Voice alias, e.g. House Owner
    var accountRef: String  // UPI or masked account

    init(id: UUID = UUID(), name: String, alias: String, accountRef: String) {
        self.id = id
        self.name = name
        self.alias = alias
        self.accountRef = accountRef
    }
}
