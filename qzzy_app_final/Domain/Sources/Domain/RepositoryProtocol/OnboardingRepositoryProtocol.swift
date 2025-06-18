//
//  OnboardingRepositoryProtocol.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Combine

public protocol OnboardingRepositoryProtocol {
  func fetchOnboardingItems() -> AnyPublisher<[OnboardingItem], Error>
  
  func fetchSelectedItems() -> AnyPublisher<SelectedItems, Error>
  
  func sendSelectedItems(ids: [Int]) -> AnyPublisher<Void, Error>
}
