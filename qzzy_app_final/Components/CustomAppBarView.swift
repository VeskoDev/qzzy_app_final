//
//  CustomAppBarView.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 23.4.25..
//

import SwiftUI

struct CustomAppBarView: View {
    var title: String

    var body: some View {
        ZStack(alignment: .bottom) {
            AppBarBackground()
            AppBarContent(title: title)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private struct AppBarBackground: View {
    var body: some View {
        Rectangle()
            .fill(MyColorScheme.softYellow)
            .customFrameAndClipShape()
    }
}

private struct AppBarContent: View {
    var title: String

    var body: some View {
        VStack {
            Text(title)
            .font(.system(size: UIConstants.FontSize.large, weight: .bold))
                .foregroundColor(MyColorScheme.darkGreen)

          Spacer().frame(height: UIConstants.Spacing.section)

            Text(GlobalConstants.onboardingInstruction)
            .font(.system(size: UIConstants.FontSize.small, weight: .light))
                .multiLine()
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(MyColorScheme.black)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.bottom, UIConstants.Padding.extraLarge)
    }
}

#Preview {
    CustomAppBarView(title: "Qzzy")
}

