//
//  FetchCategoriesUseCase.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Combine


public class FetchOnboardingItemsUseCase {
  private let onboardingRepository: OnboardingRepositoryProtocol
  
  public init(onboardingRepository: OnboardingRepositoryProtocol) {
    self.onboardingRepository = onboardingRepository
  }
  
  public func execute() -> AnyPublisher<[OnboardingItem], Error> {
    return onboardingRepository.fetchOnboardingItems()
  }}
