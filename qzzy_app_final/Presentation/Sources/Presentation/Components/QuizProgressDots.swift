//
//  QuizProgressDots.swift
//  Presentation
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//

import SwiftUI

struct QuizProgressDots: View {
  @Binding var selectedIndex: Int
  let questions: [QuestionUIModel]
  
  var body: some View {
    
    HStack {
      ForEach(questions.indices, id: \.self) { index in
        let question = questions[index]
        Button(action: {
          selectedIndex = index
        }) {
          Text("\(index + 1)")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(question.status.indicatorColor)
          
            .frame(width: 50, height: 50)
            .background(
              Circle()
                .fill(question.status.backgroundColor)
            )
            .overlay(
              Circle()
                .stroke(selectedIndex == index ? Color.white : Color.clear, lineWidth: 2)
            )
        }
        Spacer()
      }
    }
    .padding(.bottom, 80)
    .padding(.horizontal, 16)
  }
}
