//
//  DepedencyManager.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation

class DependencyManager {
    
    static let shared: DependencyManager = {
        return DependencyManager()
    }()
    
    lazy var networkManager: NetworkManager = {
        return NetworkManager.shared
    }()
    
    lazy var onboardingRepository: OnboardingRepositoryProtocol = {
        return OnboardingRepository(networkManager: networkManager)
    }()
    
    lazy var fetchOnboardingItemsUseCase: FetchOnboardingItemsUseCase = {
        return FetchOnboardingItemsUseCase(onboardingRepository: onboardingRepository)
    }()
}
