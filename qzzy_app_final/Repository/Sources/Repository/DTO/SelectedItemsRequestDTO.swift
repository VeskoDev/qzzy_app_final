//
//  SelectedItemsRequestDTO.swift
//  Repository
//
//  Created by Veselin Lazarevic on 10. 6. 2025..
//

public struct SelectedItemsRequestDTO: Encodable {
  public let categoryIds: [Int]
  
  public init(categoryIds: [Int]) {
    self.categoryIds = categoryIds
  }
}
