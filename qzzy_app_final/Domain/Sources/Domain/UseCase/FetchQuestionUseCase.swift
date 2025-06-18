//
//  FetchQuestionUseCase.swift
//  Domain
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//

import Combine

public class FetchQuestionsUseCase {
  
  private let repository: QuestionsRepositoryProtocol
  
  public init(repository: QuestionsRepositoryProtocol) {
    self.repository = repository
  }
  
  public func execute() -> AnyPublisher<[Question], Error> {
    return repository.fetchQuestions()
      .eraseToAnyPublisher()
  }
}
