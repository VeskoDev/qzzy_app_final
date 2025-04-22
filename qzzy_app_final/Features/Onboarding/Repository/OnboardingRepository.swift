//
//  OnboardingRepository.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Combine
import Alamofire

class OnboardingRepository: OnboardingRepositoryProtocol {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

  func fetchOnboardingItems() -> AnyPublisher<[OnboardingItem], AFError> {
      return networkManager
          .fetchWithoutReq(url: .categories, method: .get)
          .map { (response: ItemsResponse<[OnboardingItemDTO]>) in
              response.items.map { $0.toDomain() }
          }
          .eraseToAnyPublisher()
  }
}

