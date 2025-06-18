//
//  QuestionResponseDTO.swift
//  Repository
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//

import Domain

struct QuestionResponseDTO: Decodable {
  let questions: [QuestionDTO]
}


struct QuestionDTO: Decodable {
  let id: Int
  let categoryId: Int?
  let question: String
  let answers: [AnswerDTO]
  
  func toDomain() -> Question {
    return Question(
      id: id,
      categoryId: categoryId,
      question: question,
      answers: answers.map { $0.toDomain() }
    )
  }
}

struct AnswerDTO: Decodable {
  let id: Int
  let answer: String
  
  func toDomain() -> Answer {
    return Answer(id: id, text: answer)
  }
}
