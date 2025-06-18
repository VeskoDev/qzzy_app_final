//
//  ContentView.swift
//  PreviewProject
//
//  Created by Veselin Lazarevic on 7.5.25..
//

import SwiftUI

struct BottomBarView: View {
    let title: String

    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack {
                    Text(title)
                        .font(.system(size: UIConstants.FontSize.medium))
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .background(MyColorScheme.darkGreen)
                        .overlay(
                            RoundedRectangle(cornerRadius: UIConstants.Radius.large)
                                .stroke(MyColorScheme.darkGreen)
                        )
                        .cornerRadius(UIConstants.Radius.large)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 24)
                .background(MyColorScheme.softYellow)
                .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct BottomBarView_Previews: PreviewProvider {
    sta
        return BottomBarView(title: "Next section")
            .previewLayout(.sizeThatFits) // Automatski prilagoditi 
            .padding() // Dodavanje paddinga za bolji izgled
    }
}
