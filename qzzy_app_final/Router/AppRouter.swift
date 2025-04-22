//
//  AppRouter.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//
import SwiftUI

final class AppRouter: ObservableObject {
    
    enum Route: Hashable, Codable {
        case onboarding
        case quizGame
        case summaryScreen
     
    }

    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
