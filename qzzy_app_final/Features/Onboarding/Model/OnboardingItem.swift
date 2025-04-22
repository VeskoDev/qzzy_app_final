//
//  OnboardingItem.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation

struct OnboardingCategory: Identifiable {
    let id: Int
    let name: String
}

struct OnboardingCountry: Identifiable {
    let id: Int
    let name: String
    let categoryId: Int
}

enum OnboardingItem: Identifiable {
    case category(OnboardingCategory)
    case country(OnboardingCountry)

    var id: Int {
        switch self {
        case .category(let cat): return cat.id
        case .country(let country): return country.id
        }
    }
}
