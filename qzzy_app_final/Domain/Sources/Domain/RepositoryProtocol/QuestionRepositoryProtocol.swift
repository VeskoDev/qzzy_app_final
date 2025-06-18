//
//  QuestionRepositoryProtocol.swift
//  Domain
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//


import Combine

public protocol QuestionsRepositoryProtocol {
  func fetchQuestions() -> AnyPublisher<[Question], Error>
  
  func checkAnswer(questionId: Int, answerId: Int) -> AnyPublisher<Bool, Error>
  
}
