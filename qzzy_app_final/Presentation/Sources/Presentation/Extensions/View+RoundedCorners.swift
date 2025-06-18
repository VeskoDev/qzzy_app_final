//
//  SwiftUIView.swift
//  
//
//  Created by Veselin Lazarevic on 24.4.25..
//

import SwiftUI


extension View {
  func customFrameAndClipShape(
    heightRatio: CGFloat = 0.35,
    radius: CGFloat = UIConstants.Radius.large,
    corners: UIRectCorner = [.bottomLeft, .bottomRight]
  ) -> some View {
    self
      .frame(height: UIScreen.main.bounds.height * heightRatio)
      .clipShape(RoundedCornerShape(corners: corners, radius: radius))
  }
}

struct RoundedCornerShape: Shape {
  var corners: UIRectCorner
  var radius: CGFloat
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}
