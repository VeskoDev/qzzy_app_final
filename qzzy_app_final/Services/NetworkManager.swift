//
//  NetworkManager.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation
import Alamofire
import Combine

class NetworkManager {
    
    static let shared: NetworkManager = {
        let configuration = URLSessionConfiguration.default
        return NetworkManager(configuration: configuration)
    }()
    
    private let session: Session
    
    private init(configuration: URLSessionConfiguration) {
        self.session = Session(configuration: configuration)
    }
    
    func fetch<T, U>(url: Config.APIEndpoint, request: U, method: HTTPMethod) -> AnyPublisher<T, AFError>
        where T: Decodable, U: Encodable {
        
        return session.request(url.url, method: method, parameters: request, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200 ..< 300)
            .publishDecodable(type: T.self)
            .value()
            .eraseToAnyPublisher()
    }
    
  func fetchWithoutReq<T>(url: Config.APIEndpoint, method: HTTPMethod) -> AnyPublisher<T, AFError> where T: Decodable {
      return session.request(url.url, method: method)
          .validate(statusCode: 200 ..< 300)
          .publishDecodable(type: T.self)
          .value()
          .eraseToAnyPublisher()
  }
    
    func fetchWithoutReqAndFail(url: Config.APIEndpoint, method: HTTPMethod) -> AnyPublisher<Result<String, AFError>, Never> {
        
        return session.request(url.url, method: method)
            .validate(statusCode: 200 ..< 300)
            .publishDecodable(type: String.self, emptyResponseCodes: [200])
            .result()
            .eraseToAnyPublisher()
    }
}

