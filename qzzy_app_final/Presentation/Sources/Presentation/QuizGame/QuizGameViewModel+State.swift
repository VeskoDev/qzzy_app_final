//
//  QuizGameViewModel+State.swift
//  Presentation
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//


import Domain
import SwiftUI

public enum AnswerStatus {
  case unanswered
  case answered
  case correct
  case incorrect
}

public struct QuestionUIModel: Identifiable {
  public let id: Int
  public let question: Question
  public var selectedAnswerId: Int?
  public var status: AnswerStatus
  
  public init(question: Question, selectedAnswerId: Int? = nil, status: AnswerStatus = .unanswered) {
    self.id = question.id
    self.question = question
    self.selectedAnswerId = selectedAnswerId
    self.status = status
  }
}

extension QuestionUIModel {
  
  func backgroundColor(for answerId: Int) -> Color {
    if selectedAnswerId == answerId && (status == .correct || status == .incorrect) {
      return status.resultColor
    }
    return Color.black.opacity(0.33)
  }

  func shouldShowBorder(for answerId: Int) -> Bool {
    return status == .answered && selectedAnswerId == answerId
  }
}
