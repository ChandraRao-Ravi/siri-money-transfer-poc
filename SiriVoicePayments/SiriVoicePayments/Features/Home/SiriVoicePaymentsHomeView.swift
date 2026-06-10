//
//  SiriVoicePaymentsHomeView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct SiriVoicePaymentsHomeView: View {
    private let beneficiaries = SiriVoiceBeneficiaryRepository.shared.all

    var body: some View {
        List {
            Section("Saved beneficiaries") {
                ForEach(beneficiaries, id: \.id) { person in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(person.nickname ?? person.name)
                            .font(.headline)
                        Text(person.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(person.upiID)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Try with Siri") {
                Text("Send 2000 rupees to Papa in SiriVoicePayments")
                Text("Transfer 500 to Mummy in SiriVoicePayments")
            }
        }
    }
}
