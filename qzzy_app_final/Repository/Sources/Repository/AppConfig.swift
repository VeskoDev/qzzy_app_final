//
//  AppConfig.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation

public struct Config {
  public static let baseUrl = "http://localhost:8080/api"
  
  public enum APIEndpoint {
    case categories
    case selectCategories
    case fetchQuestions
    case checkAnswer(questionId: Int, answerId: Int)
    
    private var path: String {
      switch self {
        case .categories:
          return "/category"
        case .selectCategories:
          return "/category/select"
        case .fetchQuestions:
          return "/questions"
        case let .checkAnswer(questionId, answerId):
          return "/questions/\(questionId)/answers/\(answerId)/correct"
      }
    }
    
    public func asURL() throws -> URL {
      guard let url = URL(string: Config.baseUrl + path) else {
        throw URLError(.badURL)
      }
      return url
    }
    
    public var url: String {
      return Config.baseUrl + path
    }
  }
}
