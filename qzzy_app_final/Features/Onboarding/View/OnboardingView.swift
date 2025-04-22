//
//  OnboardingView.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import SwiftUI


struct OnboardingView: View {
    @ObservedObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                OnboardingListView(onboardingItems: viewModel.onboardingItems)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchOnboardingItems()
        }
        .navigationTitle(GlobalConstants.onboarding)
    }
}

private struct OnboardingListView: View {
    let onboardingItems: [OnboardingItem]

    var body: some View {
        List {
            ForEach(onboardingItems) { item in
                switch item {
                case .category(let category):
                    Text("Category: \(category.name)")
                case .country(let country):
                    Text("Country: \(country.name)")
                }
            }
        }
    }
}


#Preview {
    OnboardingView()
}
