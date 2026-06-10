//
//  Transaction.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation

struct Transaction: Identifiable, Hashable {
    enum Direction: String {
        case debit
        case credit
    }

    let id: UUID
    let date: Date
    let amount: Decimal
    let direction: Direction
    let payeeAlias: String
    let description: String
}
