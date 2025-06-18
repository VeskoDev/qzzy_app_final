//
//  QuesionResponse.swift
//  Domain
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//


public struct Question {
  public let id: Int
  public let categoryId: Int?
  public let question: String
  public let answers: [Answer]
  
  public init(id: Int, categoryId: Int?, question: String, answers: [Answer]) {
    self.id = id
    self.categoryId = categoryId
    self.question = question
    self.answers = answers
  }
}

public struct Answer {
  public let id: Int
  public let text: String
  
  public init(id: Int, text: String) {
    self.id = id
    self.text = text
  }
}
