//
//  FetchSelectedCategoriesUseCase.swift
//  Domain
//
//  Created by Veselin Lazarevic on 10. 6. 2025..
//


import Foundation
import Combine


public class FetchSelectedCategoriesUseCase {
  private let onboardingRepository: OnboardingRepositoryProtocol
  
  public init(onboardingRepository: OnboardingRepositoryProtocol) {
    self.onboardingRepository = onboardingRepository
  }
  
  public func execute() -> AnyPublisher<SelectedItems, Error> {
    return onboardingRepository.fetchSelectedItems()
  }}
