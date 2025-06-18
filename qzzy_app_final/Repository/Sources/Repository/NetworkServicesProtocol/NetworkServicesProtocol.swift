//
//  File.swift
//  
//
//  Created by Veselin Lazarevic on 24.4.25..
//


import Combine
import Foundation

public enum AppHTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
}

public enum AppNetworkError: Error, Equatable {
  case invalidURL
  case decodingError(Error)
  case apiError(statusCode: Int, data: Data?)
  case noConnection
  case unknown(Error?)
  case noData
  case custom(String)
  
  public static func == (lhs: AppNetworkError, rhs: AppNetworkError) -> Bool {
    switch (lhs, rhs) {
      case (.invalidURL, .invalidURL): return true
      case (.decodingError(let lhsError), .decodingError(let rhsError)):
        return lhsError.localizedDescription == rhsError.localizedDescription
      case (.apiError(let sc1, _), .apiError(let sc2, _)): return sc1 == sc2
      case (.noConnection, .noConnection): return true
      case (.unknown(let lhsError), .unknown(let rhsError)):
        return lhsError?.localizedDescription == rhsError?.localizedDescription
      case (.noData, .noData): return true
      case (.custom(let s1), .custom(let s2)): return s1 == s2
      default: return false
    }
  }
}

public protocol NetworkManagerProtocol {
  func fetch<T: Decodable, U: Encodable>(
    url: Config.APIEndpoint,
    request: U,
    method: AppHTTPMethod
  ) -> AnyPublisher<T, AppNetworkError>
  
  func fetchWithoutReq<T: Decodable>(
    url: Config.APIEndpoint,
    method: AppHTTPMethod
  ) -> AnyPublisher<T, AppNetworkError>
  
  func fetchWithoutReqAndFail(
    url: Config.APIEndpoint,
    method: AppHTTPMethod
  ) -> AnyPublisher<Result<String, AppNetworkError>, Never>
  
  func send<U: Encodable>(
    url: Config.APIEndpoint,
    request: U,
    method: AppHTTPMethod
  ) -> AnyPublisher<Void, AppNetworkError> 
}

