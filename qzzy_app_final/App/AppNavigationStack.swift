//
//  AppNavigationStack.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 17. 6. 2025..
//


import SwiftUI

struct HideBackButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
    }
}

extension View {
    func hideBackButton() -> some View {
        self.modifier(HideBackButton())
    }
}
