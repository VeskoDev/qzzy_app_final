//
//  DepedencyManager.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Domain
import NetworkServices
import Repository
import Presentation

class DependencyManager {
  
  
  lazy var networkManager: NetworkManager = {
    return NetworkManager(configuration: .default)
  }()
  
  lazy var urlSessionsManager: URLSessionNetworkManager = {
    return URLSessionNetworkManager(configuration: .default)
  }()
  
  //    lazy var onboardingRepository: OnboardingRepositoryProtocol = {
  //        return OnboardingRepository(networkManager: networkManager)
  //    }()
  //
  lazy var onboardingRepository: OnboardingRepositoryProtocol = {
    return OnboardingRepository(networkManager: urlSessionsManager)
  }()
  
  lazy var questionsRepository: QuestionsRepositoryProtocol = {
    return QuestionsRepository(networkManager: urlSessionsManager)
  }()
  
  
  lazy var fetchOnboardingItemsUseCase: FetchOnboardingItemsUseCase = {
    return FetchOnboardingItemsUseCase(onboardingRepository: onboardingRepository)
  }()
  
  
  lazy var fetchSelectedCategoriesUseCase: FetchSelectedCategoriesUseCase = {
    return FetchSelectedCategoriesUseCase(onboardingRepository: onboardingRepository)
  }()
  
  
  lazy var sendSelectedOnboardingItemsUseCase: SendSelectedOnboardingItemsUseCase = {
    return SendSelectedOnboardingItemsUseCase(onboardingRepository: onboardingRepository)
  }()
  
  
  lazy var fetchSelectedAndCombinedItems: FetchCombinedOnboardingItemsUseCase = {
    return FetchCombinedOnboardingItemsUseCase(fetchOnboardingItemsUseCase: fetchOnboardingItemsUseCase, fetchSelectedCategoriesUseCase: fetchSelectedCategoriesUseCase)
  }()
  
  lazy var checkAnswerUseCase: CheckAnswerUseCase = {
    return CheckAnswerUseCase(repository:questionsRepository )
  }()
  
  
  lazy var fetchQuestionsUseCase: FetchQuestionsUseCase = {
    return FetchQuestionsUseCase(repository: questionsRepository)
  }()
  
  lazy var onboardingViewModel: OnboardingViewModel = {
    return OnboardingViewModel(fetchCombinedOnboardingItemsUseCase: fetchSelectedAndCombinedItems, sendSelectedOnboardingItemsUseCase: sendSelectedOnboardingItemsUseCase)
  }()
  
  
  lazy var quizViewModel: QuizViewModel = {
    return QuizViewModel(
      fetchQuestionsUseCase: fetchQuestionsUseCase,
      checkAnswerUseCase: checkAnswerUseCase
    )
  }()
  
  
}
