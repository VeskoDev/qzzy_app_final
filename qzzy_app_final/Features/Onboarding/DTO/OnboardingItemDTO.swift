//
//  OnboardingItemDTO.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation


struct ItemsResponse<T: Decodable>: Decodable {
    let items: T
}

struct OnboardingItemDTO: Codable {
    let id: Int
    let name: String
    let categoryId: CategoryId?

    func toDomain() -> OnboardingItem {
        guard let categoryId = categoryId else {
            return .category(OnboardingCategory(id: id, name: name))
        }
        
        switch categoryId {
        case .intValue(let categoryId):
            return .country(OnboardingCountry(id: id, name: name, categoryId: categoryId))
        case .stringValue(let categoryId):
            if let intCategoryId = Int(categoryId) {
                return .country(OnboardingCountry(id: id, name: name, categoryId: intCategoryId))
            }
            return .category(OnboardingCategory(id: id, name: name))
        }
    }
}

enum CategoryId: Codable {
    case intValue(Int)
    case stringValue(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .intValue(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .stringValue(stringValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid categoryId format")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .intValue(let value):
            try container.encode(value)
        case .stringValue(let value):
            try container.encode(value)
        }
    }
}
