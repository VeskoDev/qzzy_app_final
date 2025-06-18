//
//  QuestionsAndAnswersRepository.swift
//  Repository
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//

import Foundation
import Combine
import Domain

public class QuestionsRepository: QuestionsRepositoryProtocol {
  
  private let networkManager: NetworkManagerProtocol
  
  public init(networkManager: NetworkManagerProtocol) {
    self.networkManager = networkManager
  }
  
  public func fetchQuestions() -> AnyPublisher<[Question], Error> {
    return networkManager
      .fetchWithoutReq(url: .fetchQuestions, method: .get)
      .map { (response: QuestionResponseDTO) in
        response.questions.map { $0.toDomain() }
      }
      .catch { error -> AnyPublisher<[Question], Error> in
        return Just([])
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  public func checkAnswer(questionId: Int, answerId: Int) -> AnyPublisher<Bool, Error> {
    return networkManager
      .fetchWithoutReq(url: .checkAnswer(questionId: questionId, answerId: answerId), method: .get)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}

