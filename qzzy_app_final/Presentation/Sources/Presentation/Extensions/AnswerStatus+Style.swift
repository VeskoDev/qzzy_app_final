//
//  AnswerStatus+Style.swift
//  Presentation
//
//  Created by Veselin Lazarevic on 17. 6. 2025..
//

import SwiftUI

extension AnswerStatus {
  var indicatorColor: Color {
    switch self {
      case .answered, .incorrect, .correct:
        return .black
      case .unanswered:
        return MyColorScheme.softYellow
    }
  }
  
  var backgroundColor: Color {
    switch self {
      case .correct:
        return MyColorScheme.softYellow
      case .incorrect:
        return MyColorScheme.softOrange
      case .answered:
        return MyColorScheme.softPurple
      case .unanswered:
        return MyColorScheme.blackOpacity33
    }
  }
  
  var resultColor: Color {
    switch self {
      case .correct:
        return MyColorScheme.softYellow
      case .incorrect:
        return MyColorScheme.softOrange
      case .unanswered, .answered:
        return MyColorScheme.blackOpacity33
    
    }
  }
}
