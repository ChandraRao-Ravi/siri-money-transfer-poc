//
//  AccountDetails.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import Foundation

struct AccountDetails: Hashable {
    let accountNumberMasked: String
    let accountType: String
    let provider: String
}
