//
//  PayeeListView.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import SwiftUI

struct PayeeListView: View {
    @EnvironmentObject var payeeStore: PayeeStore
    @State private var showAddPayee = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if payeeStore.payees.isEmpty {
                        Text("No payees yet. Add your first payee.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(payeeStore.payees) { payee in
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
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: payeeStore.deletePayees)
                    }
                }
            }
            .navigationTitle("Payees")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddPayee = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddPayee) {
                AddPayeeView()
                    .environmentObject(payeeStore)
            }
        }
    }
}
