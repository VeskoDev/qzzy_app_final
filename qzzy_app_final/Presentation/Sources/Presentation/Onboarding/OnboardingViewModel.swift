//
//  OnboardingViewModel.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//


import Foundation
import Combine
import Domain
import SwiftUI
import Combine

public final class OnboardingViewModel: ObservableObject {
  private let fetchCombinedOnboardingItemsUseCase: FetchCombinedOnboardingItemsUseCase
  private let sendSelectedOnboardingItemsUseCase: SendSelectedOnboardingItemsUseCase
  
  @Published public private(set) var state: OnboardingViewState = .idle
  
  private var cancellables = Set<AnyCancellable>()
  
  public init(
    fetchCombinedOnboardingItemsUseCase: FetchCombinedOnboardingItemsUseCase,
    sendSelectedOnboardingItemsUseCase: SendSelectedOnboardingItemsUseCase
  ) {
    self.fetchCombinedOnboardingItemsUseCase = fetchCombinedOnboardingItemsUseCase
    self.sendSelectedOnboardingItemsUseCase = sendSelectedOnboardingItemsUseCase
  }
  
  public func loadOnboardingItems() {
    guard case .idle = state else { return }
    
    state = .loading
    
    fetchCombinedOnboardingItemsUseCase.execute()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.state = .error("Failed to load onboarding items: \(error.localizedDescription)")
        }
      } receiveValue: { [weak self] items in
        guard let self = self else { return }
        self.state = .loaded(step: .categories, items: items)
      }
      .store(in: &cancellables)
  }
  
  public func toggleSelection(for item: OnboardingItemWithSelection) {
    guard case .loaded(let step, var items) = state else { return }
    
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index].isSelected.toggle()
      
      if case .category(let category) = item.item {
        let isSelected = items[index].isSelected
        for i in items.indices {
          if case .country(let country) = items[i].item, country.categoryId == category.id {
            items[i].isSelected = isSelected
          }
        }
      }
      state = .loaded(step: step, items: items)
    }
  }
  
  public func transition(to step: OnboardingStep) {
      guard case .loaded(let currentStep, let items) = state else { return }

      state = .transitioning(to: step, from: currentStep, items: items)

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          withAnimation(.easeInOut) {
              self.state = .loaded(step: step, items: items)
          }
      }
  }
  
  public func sendSelectedItems() {
    guard case .loaded(_, let items) = state else { return }
    
    let selectedIDs = items
      .filter { $0.isSelected }
      .map { $0.id }
    
    sendSelectedOnboardingItemsUseCase.execute(ids: selectedIDs)
      .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
      .store(in: &cancellables)
  }
  
  
  public func groupedItemsByCategory(from items: [OnboardingItemWithSelection]) -> [(OnboardingCategory, [OnboardingItemWithSelection])] {
      let categories = items.compactMap {
          if case .category(let cat) = $0.item { return cat }
          return nil
      }

      let countries = items.compactMap {
          if case .country = $0.item { return $0 }
          return nil
      }

      let sortedCategories = categories.sorted(by: { $0.name < $1.name })

      return sortedCategories.map { category in
          let filtered = countries.filter {
              if case .country(let c) = $0.item {
                  return c.categoryId == category.id
              }
              return false
          }

          if filtered.isEmpty {
              let synthesizedCountry = OnboardingCountry(
                  id: category.id,
                  name: category.name,
                  categoryId: category.id
              )
              
              let synthesizedItem = OnboardingItemWithSelection(
                  item: .country(synthesizedCountry),
                  isSelected: false
              )
              
              return (category, [synthesizedItem])
          } else {
              return (category, filtered)
          }
      }
  }
}
