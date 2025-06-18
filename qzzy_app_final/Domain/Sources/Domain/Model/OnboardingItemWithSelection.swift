//
//  OnboardingItemWithSelection.swift
//  Domain
//
//  Created by Veselin Lazarevic on 10. 6. 2025..
//


import Foundation

public struct OnboardingItemWithSelection: Identifiable {
  public let item: OnboardingItem
  public var isSelected: Bool
  
  public init(item: OnboardingItem, isSelected: Bool) {
    self.item = item
    self.isSelected = isSelected
  }
  
  public var id: Int {
    item.id
  }

}
