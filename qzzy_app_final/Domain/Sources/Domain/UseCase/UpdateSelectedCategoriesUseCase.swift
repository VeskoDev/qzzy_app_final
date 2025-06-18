//
//  UpdateSelectedCategoriesUseCase.swift
//  Domain
//
//  Created by Veselin Lazarevic on 10. 6. 2025..
//

import Foundation
import Combine

public class SendSelectedOnboardingItemsUseCase {
  
  private let onboardingRepository: OnboardingRepositoryProtocol
  
  public init(onboardingRepository: OnboardingRepositoryProtocol) {
    self.onboardingRepository = onboardingRepository
  }
  
  public func execute(ids: [Int]) -> AnyPublisher<Void, Error> {
    return onboardingRepository.sendSelectedItems(ids: ids)
      .eraseToAnyPublisher()
  }
}
