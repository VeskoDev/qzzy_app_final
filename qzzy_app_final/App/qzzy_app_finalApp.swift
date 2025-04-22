//
//  qzzy_app_finalApp.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import SwiftUI

@main
struct TheQzzyApp: App {
    @StateObject var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                OnboardingView()
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        switch route {
                        case .onboarding:
                            OnboardingView()
                        case .quizGame:
                            Text("Quiz Game Screen")
                        case .summaryScreen:
                            Text("Summary Screen")
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
