//
//  AppConfig.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import Foundation

struct Config {
    static let baseUrl = "http://localhost:8080/api"
  
  enum APIEndpoint: String {
      case categories = "/category"
      case selectCategories = "/category/select"
    
      var url: String {
          return Config.baseUrl + self.rawValue
      }
  }
}
