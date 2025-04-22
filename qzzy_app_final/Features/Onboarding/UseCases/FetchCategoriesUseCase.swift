//
//  FetchCategoriesUseCase.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Combine
import Alamofire


class FetchOnboardingItemsUseCase {
    private let onboardingRepository: OnboardingRepositoryProtocol

    init(onboardingRepository: OnboardingRepositoryProtocol) {
        self.onboardingRepository = onboardingRepository
    }

    func execute() -> AnyPublisher<[OnboardingItem], AFError> {
        onboardingRepository.fetchOnboardingItems()
    }
}
