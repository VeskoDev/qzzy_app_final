//
//  OnboardingItem.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 24.4.25..
//


import Foundation

public struct OnboardingCategory: Identifiable, Hashable {
  public let id: Int
  public let name: String
  
  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

public struct OnboardingCountry: Identifiable, Hashable {
  public let id: Int
  public let name: String
  public let categoryId: Int
  
  public init(id: Int, name: String, categoryId: Int) {
    self.id = id
    self.name = name
    self.categoryId = categoryId
  }
}

public enum OnboardingItem: Identifiable {
  case category(OnboardingCategory)
  case country(OnboardingCountry)
  
  public var id: Int {
    switch self {
      case .category(let cat): return cat.id
      case .country(let country): return country.id
    }
  }
  
  public var name: String {
    switch self {
      case .category(let category):
        return category.name
      case .country(let country):
        return country.name
    }
  }
}
