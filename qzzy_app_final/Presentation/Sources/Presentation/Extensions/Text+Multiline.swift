//
//  SwiftUIView 3.swift
//  
//
//  Created by Veselin Lazarevic on 24.4.25..
//

import SwiftUI

extension Text {
  func multiLine(limit: Int = 2) -> some View {
    self
      .lineLimit(limit)
      .fixedSize(horizontal: false, vertical: true)
  }
}
