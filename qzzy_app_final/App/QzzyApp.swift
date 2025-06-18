//
//  qzzy_app_finalApp.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import SwiftUI
import Presentation

@main
struct TheQzzyApp: App {
  @StateObject private var router = AppRouter()
  private let dependencies = DependencyManager()

  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.path) {
        OnboardingView(viewModel: dependencies.onboardingViewModel)
          .navigationDestination(for: AppRouter.Route.self) { route in
            switch route {
              case .onboarding:
                OnboardingView(viewModel: dependencies.onboardingViewModel)
                  .hideBackButton()
              case .quizGame:
                QuizGameView(viewModel: dependencies.quizViewModel)
                  .hideBackButton()
              case .summaryScreen:
                SummaryView(viewModel: dependencies.quizViewModel)
                  .hideBackButton()
            }
          }
      }
      .environmentObject(router)
    }
  }
}
