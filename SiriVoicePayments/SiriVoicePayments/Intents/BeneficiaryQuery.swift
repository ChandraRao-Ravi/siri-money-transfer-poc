//
//  BeneficiaryQuery.swift
//  SiriVoicePayments
//
//  Created by Chandra Rao on 10/06/26.
//

import AppIntents

// Conform to EntityStringQuery to handle text-based lookups cleanly
struct BeneficiaryQuery: EntityStringQuery {

    func entities(for identifiers: [String]) async throws -> [BeneficiaryEntity] {
        let all = await MainActor.run { SiriVoiceBeneficiaryRepository.shared.all }
        return all
            .filter { identifiers.contains($0.id) }
            .map { BeneficiaryEntity(id: $0.id, name: $0.name, upiID: $0.upiID) }
    }

    func suggestedEntities() async throws -> [BeneficiaryEntity] {
        let all = await MainActor.run { SiriVoiceBeneficiaryRepository.shared.all }
        return all.map { BeneficiaryEntity(id: $0.id, name: $0.name, upiID: $0.upiID) }
    }

    func entities(matching string: String) async throws -> [BeneficiaryEntity] {
        let all = await MainActor.run { SiriVoiceBeneficiaryRepository.shared.all }
        return all.filter {
            $0.name.localizedCaseInsensitiveContains(string) ||
            ($0.nickname?.localizedCaseInsensitiveContains(string) ?? false)
        }
        .map { BeneficiaryEntity(id: $0.id, name: $0.name, upiID: $0.upiID) }
    }
}
