//
//  AddPayeeView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct AddPayeeView: View {
    @EnvironmentObject var payeeStore: PayeeStore
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var alias: String = ""
    @State private var accountRef: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Payee info")) {
                    TextField("Full name", text: $name)
                    TextField("Alias (e.g. House Owner)", text: $alias)
                    TextField("Account / UPI ID", text: $accountRef)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
            }
            .navigationTitle("Add payee")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty ||
                                  accountRef.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        payeeStore.addPayee(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            alias: alias.trimmingCharacters(in: .whitespacesAndNewlines),
            accountRef: accountRef.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        dismiss()
    }
}
