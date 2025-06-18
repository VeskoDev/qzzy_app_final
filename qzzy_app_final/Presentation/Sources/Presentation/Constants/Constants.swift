//
//  File.swift
//  
//
//  Created by Veselin Lazarevic on 24.4.25..
//

import Foundation

final class Constants {
  static let title = "Qzzy"
  static let onboardingInstruction = "Select a minimum of 3 categories"
  static let quizCompletionMessage = "Well done!"
  static let quizRetryMessage = "Try Again!"
  static let letsRollMessage = "Let's roll!"
  
  static func questionProgress(current index: Int, total: Int) -> String {
    return "Question \(index + 1)/\(total)"
  }
  
  static func scoreText(correct: Int, total: Int) -> String {
    return "You scored\n\(correct) out of \(total)"
  }
  
  static let nextSectionLabel = "Next section"
}
