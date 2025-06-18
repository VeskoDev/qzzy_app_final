//
//  SwiftUIView.swift
//  
//
//  Created by Veselin Lazarevic on 24.4.25..
//

import SwiftUI


enum PageType {
  case onboarding
  case subOnboarding
}

struct CustomAppBarView: View {
  var title: String
  var page: PageType?
  
  var body: some View {
    ZStack(alignment: .top) {
      AppBarBackground(heightRatio: page == .onboarding ? 0.33 : 0.22, color: MyColorScheme.softYellow)
      AppBarContent(title: title, showInstruction: page == .onboarding)
    }
    .edgesIgnoringSafeArea(.top)
  }
}


private struct AppBarContent: View {
  var title: String
  var showInstruction: Bool
  
  var body: some View {
    VStack {
      Text(title)
        .font(.system(size: UIConstants.FontSize.large, weight: .bold))
        .foregroundColor(MyColorScheme.darkGreen)
      
      Spacer().frame(height: UIConstants.Spacing.section)
      
      if showInstruction {
        OnboardingInstructionText()
      }
    }
    .multilineTextAlignment(.center)
    .frame(maxWidth: .infinity)
    .padding(.top, UIConstants.Padding.extraLarge)
  }
}

private struct OnboardingInstructionText: View {
  var body: some View {
    Text(Constants.onboardingInstruction)
      .font(.system(size: UIConstants.FontSize.small, weight: .light))
      .multiLine()
      .fixedSize(horizontal: false, vertical: true)
      .foregroundColor(MyColorScheme.black)
  }
}

