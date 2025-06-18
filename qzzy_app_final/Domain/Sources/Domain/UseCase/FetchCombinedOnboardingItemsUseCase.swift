//
//  FetchCombinedOnboardingItemsUseCase.swift
//  Domain
//
//  Created by Veselin Lazarevic on 10. 6. 2025..
//


import Foundation
import Combine

public class FetchCombinedOnboardingItemsUseCase {
  private let fetchOnboardingItemsUseCase: FetchOnboardingItemsUseCase
  private let fetchSelectedCategoriesUseCase: FetchSelectedCategoriesUseCase
  
  public init(
    fetchOnboardingItemsUseCase: FetchOnboardingItemsUseCase,
    fetchSelectedCategoriesUseCase: FetchSelectedCategoriesUseCase
  ) {
    self.fetchOnboardingItemsUseCase = fetchOnboardingItemsUseCase
    self.fetchSelectedCategoriesUseCase = fetchSelectedCategoriesUseCase
  }
  
  public func execute() -> AnyPublisher<[OnboardingItemWithSelection], Error> {
    
    Publishers.CombineLatest(
      fetchOnboardingItemsUseCase.execute(),
      fetchSelectedCategoriesUseCase.execute()
    )
    .map { (allOnboardingItems, selectedItems) in
      let selectedIDs = Set(selectedItems.ids)
      
      return allOnboardingItems.map { item in
        let isSelected = selectedIDs.contains(item.id)
        return OnboardingItemWithSelection(item: item, isSelected: isSelected)
      }
    }
    .eraseToAnyPublisher()
  }
}
