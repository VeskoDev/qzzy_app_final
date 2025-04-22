//
//  OnboardingViewModel.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    private let fetchOnboardingItemsUseCase: FetchOnboardingItemsUseCase
  
    @Published var onboardingItems: [OnboardingItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchOnboardingItemsUseCase: FetchOnboardingItemsUseCase = DependencyManager.shared.fetchOnboardingItemsUseCase) {
        self.fetchOnboardingItemsUseCase = fetchOnboardingItemsUseCase
    }
    
    func fetchOnboardingItems() {
      
      guard !isLoading && onboardingItems.isEmpty else
      {
        return
      }
        isLoading = true
        errorMessage = nil
        
        fetchOnboardingItemsUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { items in
                self.onboardingItems = items
            })
            .store(in: &cancellables)
    }
}
