//
//  AppBarComponent.swift
//  Presentation
//
//  Created by Veselin Lazarevic on 17. 6. 2025..
//

import SwiftUI


public struct AppBarBackground: View {
  private let heightRatio: CGFloat
  private let color: Color
  
  public init(heightRatio: CGFloat, color: Color) {
    self.heightRatio = heightRatio
    self.color = color
  }
  
  public var body: some View {
    Rectangle()
      .fill(color)
      .frame(maxWidth: .infinity)
      .customFrameAndClipShape(heightRatio: heightRatio)
  }
}
