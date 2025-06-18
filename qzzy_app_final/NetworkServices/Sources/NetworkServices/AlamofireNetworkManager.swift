//
//  NetworkManager.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Alamofire
import Combine
import Repository

public class NetworkManager: NetworkManagerProtocol {

  public static let shared: NetworkManager = {
    let configuration = URLSessionConfiguration.default
    return NetworkManager(configuration: configuration)
  }()
  
  private let session: Session
  
  public init(configuration: URLSessionConfiguration) {
    self.session = Session(configuration: configuration)
  }
  
  private func toAlamofireMethod(_ method: AppHTTPMethod) -> HTTPMethod {
    return HTTPMethod(rawValue: method.rawValue)
  }
  
  public func fetch<T, U>(url: Config.APIEndpoint, request: U, method: AppHTTPMethod) -> AnyPublisher<T, AppNetworkError>
  where T: Decodable, U: Encodable {
    
    return session.request(url.url, method: toAlamofireMethod(method), parameters: request, encoder: JSONParameterEncoder.default)
      .validate(statusCode: 200..<300)
      .publishDecodable(type: T.self)
      .value()
      .mapError { afError -> AppNetworkError in
        return self.mapAFErrorToAppNetworkError(afError)
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchWithoutReq<T>(url: Config.APIEndpoint, method: AppHTTPMethod) -> AnyPublisher<T, AppNetworkError> where T: Decodable {
    return session.request(url.url, method: toAlamofireMethod(method))
      .validate(statusCode: 200..<300)
      .publishDecodable(type: T.self)
      .value()
      .mapError { afError -> AppNetworkError in
        return self.mapAFErrorToAppNetworkError(afError)
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchWithoutReqAndFail(url: Config.APIEndpoint, method: AppHTTPMethod) -> AnyPublisher<Result<String, AppNetworkError>, Never> {
    return session.request(url.url, method: toAlamofireMethod(method))
      .validate(statusCode: 200..<300)
      .publishDecodable(type: String.self, emptyResponseCodes: [200])
      .result()
      .map { afResult -> Result<String, AppNetworkError> in
        switch afResult {
          case .success(let value):
            return .success(value)
          case .failure(let afError):
            return .failure(self.mapAFErrorToAppNetworkError(afError))
        }
      }
      .eraseToAnyPublisher()
  }
  
  private func mapAFErrorToAppNetworkError(_ afError: AFError) -> AppNetworkError {
    if let underlyingError = afError.underlyingError as? URLError {
      switch underlyingError.code {
        case .notConnectedToInternet, .cancelled, .timedOut:
          return .noConnection
        case .badURL:
          return .invalidURL
        default:
          return .unknown(underlyingError)
      }
    }
    
    if case .responseValidationFailed(reason: let reason) = afError {
      switch reason {
        case .unacceptableStatusCode(code: let statusCode):
          
          return .apiError(statusCode: statusCode, data: nil)
        default:
          if let responseCode = afError.responseCode {
            return .apiError(statusCode: responseCode, data: nil)
          }
          return .unknown(afError)
      }
    }
    
    if afError.isResponseSerializationError {
      return .decodingError(afError.underlyingError ?? afError)
    }
    
    if let responseCode = afError.responseCode {
      return .apiError(statusCode: responseCode, data: nil)
    }
    
    return .unknown(afError)
  }
  
  public func send<U>(url: Config.APIEndpoint, request: U, method: AppHTTPMethod) -> AnyPublisher<Void, AppNetworkError> where U: Encodable {
    return session.request(url.url, method: toAlamofireMethod(method), parameters: request, encoder: JSONParameterEncoder.default)
      .validate(statusCode: 200..<300)
      .publishData()
      .tryMap { response -> Void in
        guard let httpResponse = response.response else {
          throw AppNetworkError.unknown(response.error)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
          throw AppNetworkError.apiError(statusCode: httpResponse.statusCode, data: response.data)
        }
        
        return Void()
      }
      .mapError { error -> AppNetworkError in
      if let afError = error as? AFError {
          return self.mapAFErrorToAppNetworkError(afError)
        } else if let appError = error as? AppNetworkError {
          return appError
        }
        return .unknown(error)
      }
      .eraseToAnyPublisher()
  }
}
