//
//  PayeePickerView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct PayeePickerView: View {
    @EnvironmentObject var payeeStore: PayeeStore
    @Environment(\.dismiss) private var dismiss

    @Binding var selected: Payee?

    var body: some View {
        NavigationStack {
            List {
                ForEach(payeeStore.payees) { payee in
                    Button {
                        selected = payee
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.teal.opacity(0.2))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text(String(payee.alias.prefix(1)).uppercased())
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.teal)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(payee.alias)
                                    .font(.headline)
                                Text(payee.name)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(payee.accountRef)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if selected?.id == payee.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollContentBackground(.automatic) // uses correct system bg for dark/light
            .navigationTitle("Choose payee")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
