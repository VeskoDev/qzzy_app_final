//
//  CheckAnswerUseCase.swift
//  Domain
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//

import Combine
public class CheckAnswerUseCase {
  
  private let repository: QuestionsRepositoryProtocol
  
  public init(repository: QuestionsRepositoryProtocol) {
    self.repository = repository
  }
  
  public func execute(questionId: Int, answerId: Int) -> AnyPublisher<Bool, Error> {
    return repository.checkAnswer(questionId: questionId, answerId: answerId)
      .eraseToAnyPublisher()
  }
}
