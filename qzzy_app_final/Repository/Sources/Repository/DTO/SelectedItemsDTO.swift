
//
//  SelectedItemsDTO.swift
//  Repository
//
//  Created by Veselin Lazarevic on 10. 6. 2025..
//


import Foundation
import Domain


public struct SelectedItemsResponseDTO: Decodable {
  public let selected: [Int]
  
  
  public func toDomain() -> SelectedItems {
    return SelectedItems(ids: self.selected)
  }
}
