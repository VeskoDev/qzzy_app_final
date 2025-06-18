//
//  SummaryView.swift
//  Presentation
//
//  Created by Veselin Lazarevic on 12. 6. 2025..
//
import SwiftUI


public struct SummaryView: View {
  @ObservedObject var viewModel: QuizViewModel
  @State private var selectedIndex: Int = -1
  @EnvironmentObject var router: AppRouter
  
  public init(viewModel: QuizViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    ZStack(alignment: .topTrailing) {
      MyColorScheme.darkGreen.ignoresSafeArea()
      
      Image(Assets.summaryIllustartion)
        .resizable()
        .scaledToFit()
        .frame(width: 350, height: 400)
        .ignoresSafeArea()
        .padding(.top, -80)
      
      VStack(alignment: .center) {
        Spacer()
        
        Text(Constants.scoreText(correct: viewModel.correctCount, total: viewModel.totalQuestions))
          .font(.system(size: 38, weight: .bold))
          .foregroundColor(MyColorScheme.softYellow)
          .multilineTextAlignment(.center)
        
        QuizProgressDots(selectedIndex: $selectedIndex, questions: viewModel.questions)
          .padding(.leading, 24)
        
        Text(Constants.quizCompletionMessage)
          .font(.system(size: 54))
          .foregroundColor(MyColorScheme.softYellow)
        
        TryAgainButton(title: Constants.quizRetryMessage) {
          router.push(.onboarding)
        }
        .padding(.bottom, 40)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .padding(.top, 50)
    }
    .enableInjection()
  }
  
  
}

private struct TryAgainButton: View {
  let title: String
  let onTap: () -> Void
  
  var body: some View {
    Text(title)
      .font(.system(size: UIConstants.FontSize.medium, weight: .bold))
      .foregroundColor(MyColorScheme.darkGreen)
      .padding()
      .frame(width: UIScreen.main.bounds.width / 2)
      .background(MyColorScheme.softYellow)
      .overlay(
        RoundedRectangle(cornerRadius: UIConstants.Radius.large)
          .stroke(MyColorScheme.darkGreen)
      )
      .cornerRadius(UIConstants.Radius.large)
      .onTapGesture {
        onTap()
      }
  }
}

