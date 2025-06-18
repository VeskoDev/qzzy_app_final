//
//  SwiftUIView.swift
//  
//
//  Created by Veselin Lazarevic on 24.4.25..
//

import SwiftUI


public final class AppRouter: ObservableObject {
  
  public enum Route: Hashable {
    case onboarding
    case quizGame
    case summaryScreen
  }
  
  @Published public var path = NavigationPath()
  
  public init() {}
  
  public func push(_ route: Route) {
    path.append(route)
  }
  
  public func pop() {
    if !path.isEmpty {
      path.removeLast()
    }
  }
  
  public func popToRoot() {
    path.removeLast(path.count)
  }
}
