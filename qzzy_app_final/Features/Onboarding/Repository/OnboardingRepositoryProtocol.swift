//
//  OnboardingRepositoryProtocol.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Combine
import Alamofire

protocol OnboardingRepositoryProtocol {
    func fetchOnboardingItems() -> AnyPublisher<[OnboardingItem], AFError>
}
