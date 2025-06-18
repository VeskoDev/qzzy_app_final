//
//  SwiftUIView.swift
//
//
//  Created by Veselin Lazarevic on 7.5.25..
//

import SwiftUI

public struct BottomBarView: View {
  let title: String
  let onTapAction: (() -> Void)?
  let showBackButton: Bool
  let onBackAction: (() -> Void)?
  
  public init(
    title: String,
    showBackButton: Bool = false,
    onTapAction: (() -> Void)? = nil,
    onBackAction: (() -> Void)? = nil
  ) {
    self.title = title
    self.onTapAction = onTapAction
    self.showBackButton = showBackButton
    self.onBackAction = onBackAction
  }
  
  public var body: some View {
    VStack {
      Spacer()
      VStack {
        ZStack {
          Text(title)
            .font(.system(size: UIConstants.FontSize.medium))
            .fontWeight(.bold)
            .foregroundColor(MyColorScheme.softYellow)
            .padding()
            .frame(width: UIScreen.main.bounds.width / 2)
            .background(MyColorScheme.darkGreen)
            .overlay(
              RoundedRectangle(cornerRadius: UIConstants.Radius.large)
                .stroke(MyColorScheme.darkGreen)
            )
            .cornerRadius(UIConstants.Radius.large)
            .onTapGesture {
              onTapAction?()
            }
          if showBackButton {
            BackButtonRow(onBack: onBackAction)
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(MyColorScheme.softYellow)
        .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
      }
    }
    .ignoresSafeArea(.container, edges: .bottom)
  }
}


private struct BackButtonRow: View {
  let onBack: (() -> Void)?
  
  var body: some View {
    HStack {
      Button(action: { onBack?() }) {
        Image(systemName: "chevron.left")
          .foregroundColor(MyColorScheme.darkGreen)
          .frame(width: 44, height: 44)
          .background(MyColorScheme.transparent)
          .clipShape(Circle())
          .overlay(
            Circle()
              .stroke(MyColorScheme.darkGreen, lineWidth: 2)
          )
      }
      .padding(.leading, 24)
      Spacer()
    }
  }
}
