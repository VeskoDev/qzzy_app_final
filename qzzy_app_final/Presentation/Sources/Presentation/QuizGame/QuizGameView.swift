//
//  QuizGameView.swift
//  Presentation
//
//  Created by Veselin Lazarevic on 10. 6. 2025..
//

import SwiftUI
import Inject
import Domain

public struct QuizGameView: View {
  @ObservedObject private var viewModel: QuizViewModel
  @State private var selectedIndex: Int = 0
  @EnvironmentObject var router: AppRouter
  @ObserveInjection private var inject
  
  public init(viewModel: QuizViewModel) {
    self._viewModel = ObservedObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    ZStack {
      LogoBackgroundView()
      
      QuizAppBar(viewModel: viewModel)
      
      ProgressFooter(
        selectedIndex: $selectedIndex,
        questions: viewModel.questions
      )
      
      QuestionPages(
        selectedIndex: $selectedIndex,
        questions: viewModel.questions,
        onAnswerSelected: handleAnswerSelected
      )
    }
    .edgesIgnoringSafeArea(.all)
    .enableInjection()
    .onAppear {
      viewModel.loadQuestions()
    }
  }
  
  private func handleAnswerSelected(questionId: Int, answerId: Int) {
    viewModel.selectAnswer(for: questionId, answerId: answerId)
    
    let isLast = selectedIndex == viewModel.questions.count - 1
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      if isLast {
        router.push(.summaryScreen)
        return
      }
      withAnimation {
        selectedIndex += 1
      }
    }
  }
}

private struct LogoBackgroundView: View {
  var body: some View {
    VStack {
      Spacer()
      HStack {
        Image(Assets.quizIllustration)
          .resizable()
          .scaledToFit()
          .padding(EdgeInsets(top: 0, leading: 150, bottom: 100, trailing: 0))
        
      }
    }
  }
}


private struct ProgressFooter: View {
  @Binding var selectedIndex: Int
  let questions: [QuestionUIModel]
  
  var body: some View {
    VStack {
      Spacer()
      QuizProgressDots(selectedIndex: $selectedIndex, questions: questions)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.leading, 24)
        .background(MyColorScheme.darkGreen)
        .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
    }
  }
}

private struct QuestionPages: View {
  @Binding var selectedIndex: Int
  let questions: [QuestionUIModel]
  let onAnswerSelected: (Int, Int) -> Void
  
  var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(Array(questions.enumerated()), id: \.offset) { index, question in
        QuestionCardView(
          question: question,
          index: index,
          onAnswerSelected: { answerId in
            onAnswerSelected(question.id, answerId)
          }
        )
        .tag(index)
        .padding(.horizontal, 32)
        .padding(.top, -100)
      }
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    .zIndex(1)
  }
}


private struct QuizAppBar: View {
  @ObservedObject var viewModel: QuizViewModel
  
  var body: some View {
    VStack() {
      ZStack(alignment: .top) {
        AppBarBackground(heightRatio: 0.15, color: MyColorScheme.darkGreen)
        
        VStack(spacing: 15) {
          Text(viewModel.displayScoreText)
            .font(.system(size: 32, weight: .bold))
            .foregroundColor(MyColorScheme.softYellow)
            .padding(.top, 53)
          
          GeometryReader { geo in
            HStack(spacing: 0) {
              if viewModel.isAnswered {
                Rectangle()
                  .fill(MyColorScheme.softYellow)
                  .frame(width: geo.size.width * viewModel.correctRatio)
                
                Rectangle()
                  .fill(MyColorScheme.softOrange)
                  .frame(width: geo.size.width * viewModel.incorrectRatio)
              } else {
                Rectangle()
                  .fill(Color.black.opacity(0.33))
                  .frame(width: geo.size.width)
              }
            }
            .cornerRadius(16)
          }
          .frame(height: 12)
          .padding(.horizontal, 24)
        }
      }
      Spacer()
    }
    
  }
}


private struct QuestionCardView: View {
  let question: QuestionUIModel
  let index: Int
  let onAnswerSelected: (Int) -> Void
  
  @State private var selectedOptionId: Int? = nil
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text(Constants.questionProgress(current: index, total: 5))
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(MyColorScheme.softYellow)
      
      Text(question.question.question)
        .font(.system(size: 20))
        .foregroundColor(.white)
      
      VStack(spacing: 16) {
        ForEach(question.question.answers, id: \.id) { answer in
          AnswerButton(answer: answer, question: question) {
            selectedOptionId = answer.id
            onAnswerSelected(answer.id)
          }
        }
      }
      .padding(.top, 30)
    }
    .padding(.horizontal, 25)
    .padding(.top)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .frame(height: 450)
    .background(MyColorScheme.darkGreen)
    .cornerRadius(24)
  }
}

private struct AnswerButton: View {
  let answer: Answer
  let question: QuestionUIModel
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
      Text(answer.text)
        .font(.system(size: 18, weight: .medium))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(
          RoundedRectangle(cornerRadius: 100)
            .fill(question.backgroundColor(for: answer.id))
        )
        .overlay(
          RoundedRectangle(cornerRadius: 100)
            .stroke(
              question.shouldShowBorder(for: answer.id)
              ? MyColorScheme.softYellow
              : Color.clear,
              lineWidth: 2
            )
        )
    }
  }
}
