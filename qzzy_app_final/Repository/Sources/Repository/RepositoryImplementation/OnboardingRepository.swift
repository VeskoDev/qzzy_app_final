//
//  OnboardingRepository.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Combine
import Domain


public class OnboardingRepository: OnboardingRepositoryProtocol {
  
  private let networkManager: NetworkManagerProtocol
  
  public init(networkManager: NetworkManagerProtocol) {
    self.networkManager = networkManager
  }
  
  public func fetchOnboardingItems() -> AnyPublisher<[OnboardingItem], Error> {
    return networkManager
      .fetchWithoutReq(url: .categories, method: .get)
      .map { (response: ItemsResponse<[OnboardingItemDTO]>) in
        response.items.map { $0.toDomain() }
      }
      .catch { error -> AnyPublisher<[OnboardingItem], Error> in
        return Just([])
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchSelectedItems() -> AnyPublisher<SelectedItems, Error> {
    return networkManager
      .fetchWithoutReq(url: .selectCategories, method: .get)
      .map { (responseDTO: SelectedItemsResponseDTO) in
        return responseDTO.toDomain()
      }
      .catch { error -> AnyPublisher<SelectedItems, Error> in
        return Just(SelectedItems(ids: []))
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  public func sendSelectedItems(ids: [Int]) -> AnyPublisher<Void, Error> {
    let requestDTO = SelectedItemsRequestDTO(categoryIds: ids)
    
    return networkManager
      .send(url: .selectCategories, request: requestDTO, method: .post)
      .mapError { networkError -> Error in
        return networkError
      }
      .eraseToAnyPublisher()
  }
  
}

