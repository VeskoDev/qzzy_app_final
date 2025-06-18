//
//  Untitled.swift
//  NetworkServices
//
//  Created by Veselin Lazarevic on 10. 6. 2025..
//


import Foundation
import Combine
import Repository

public class URLSessionNetworkManager: NetworkManagerProtocol {
  
  
  public static let shared: URLSessionNetworkManager = {
    let configuration = URLSessionConfiguration.default
    return URLSessionNetworkManager(configuration: configuration)
  }()
  
  private let session: URLSession
  private let jsonDecoder: JSONDecoder
  
  public init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
    self.jsonDecoder = JSONDecoder()
  }
  
  private func toURLRequestMethod(_ method: AppHTTPMethod) -> String {
    return method.rawValue
  }
  
  public func fetch<T, U>(url: Config.APIEndpoint, request: U, method: AppHTTPMethod) -> AnyPublisher<T, AppNetworkError>
  where T: Decodable, U: Encodable {
    
    guard let requestURL = URL(string: url.url) else { // Ispravljeno
      return Fail(error: AppNetworkError.invalidURL)
        .eraseToAnyPublisher()
    }
    
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = toURLRequestMethod(method)
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      urlRequest.httpBody = try JSONEncoder().encode(request)
    } catch {
      return Fail(error: AppNetworkError.decodingError(error))
        .eraseToAnyPublisher()
    }
    
    return session.dataTaskPublisher(for: urlRequest)
      .tryMap { (data, response) -> Data in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw AppNetworkError.unknown(nil)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
          throw AppNetworkError.apiError(statusCode: httpResponse.statusCode, data: data)
        }
        return data
      }
      .decode(type: T.self, decoder: jsonDecoder)
      .mapError { error -> AppNetworkError in
        return self.mapURLErrorToAppNetworkError(error)
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchWithoutReq<T>(url: Config.APIEndpoint, method: AppHTTPMethod) -> AnyPublisher<T, AppNetworkError> where T: Decodable {
    
    guard let requestURL = URL(string: url.url) else {
      return Fail(error: AppNetworkError.invalidURL)
        .eraseToAnyPublisher()
    }
    
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = toURLRequestMethod(method)
    
    return session.dataTaskPublisher(for: urlRequest)
      .tryMap { (data, response) -> Data in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw AppNetworkError.unknown(nil)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
          throw AppNetworkError.apiError(statusCode: httpResponse.statusCode, data: data)
        }
        return data
      }
      .decode(type: T.self, decoder: jsonDecoder)
      .mapError { error -> AppNetworkError in
        return self.mapURLErrorToAppNetworkError(error)
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchWithoutReqAndFail(url: Config.APIEndpoint, method: AppHTTPMethod) -> AnyPublisher<Result<String, AppNetworkError>, Never> {
    
    guard let requestURL = URL(string: url.url) else { 
      return Just(Result<String, AppNetworkError>.failure(.invalidURL))
        .eraseToAnyPublisher()
    }
    
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = toURLRequestMethod(method)
    
    return session.dataTaskPublisher(for: urlRequest)
      .map { (data, response) -> Result<String, AppNetworkError> in
        guard let httpResponse = response as? HTTPURLResponse else {
          return .failure(.unknown(nil))
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
          return .failure(.apiError(statusCode: httpResponse.statusCode, data: data))
        }
        
        if let str = String(data: data, encoding: .utf8), !str.isEmpty {
          return .success(str)
        } else if httpResponse.statusCode == 200 && data.isEmpty {
          return .success("")
        } else {
          return .failure(.noData)
        }
      }
      .catch { error -> Just<Result<String, AppNetworkError>> in
        return Just(.failure(self.mapURLErrorToAppNetworkError(error)))
      }
      .eraseToAnyPublisher()
  }
  
  
  public func send<U>(url: Config.APIEndpoint, request: U, method: AppHTTPMethod) -> AnyPublisher<Void, AppNetworkError> where U: Encodable {
    
    guard let requestURL = URL(string: url.url) else {
      return Fail(error: AppNetworkError.invalidURL)
        .eraseToAnyPublisher()
    }
    
    var urlRequest = URLRequest(url: requestURL)
    urlRequest.httpMethod = toURLRequestMethod(method)
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      urlRequest.httpBody = try JSONEncoder().encode(request)
    } catch {
      return Fail(error: AppNetworkError.decodingError(error))
        .eraseToAnyPublisher()
    }
    
    return session.dataTaskPublisher(for: urlRequest)
      .tryMap { (data, response) -> Void in 
        guard let httpResponse = response as? HTTPURLResponse else {
          throw AppNetworkError.unknown(nil)
        }
        
        
        guard 200..<300 ~= httpResponse.statusCode else {
          throw AppNetworkError.apiError(statusCode: httpResponse.statusCode, data: data)
        }
        
        return Void()
      }
      .mapError { error -> AppNetworkError in
        return self.mapURLErrorToAppNetworkError(error)
      }
      .eraseToAnyPublisher()
  }
  
  private func mapURLErrorToAppNetworkError(_ error: Error) -> AppNetworkError {
    if let urlError = error as? URLError {
      switch urlError.code {
        case .notConnectedToInternet, .cancelled, .timedOut:
          return .noConnection
        case .badURL:
          return .invalidURL
        default:
          return .unknown(urlError)
      }
    } else if let decodingError = error as? DecodingError {
      return .decodingError(decodingError)
    } else if let appError = error as? AppNetworkError {
      return appError
    }
    
    return .unknown(error)
  }
}
