//
//  OnboardingView.swift
//  qzzy_app_final
//
//  Created by Veselin Lazarevic on 22.4.25..
//

import SwiftUI
import Domain

public struct OnboardingView: View {
  @ObservedObject private var viewModel: OnboardingViewModel
  
  @EnvironmentObject var router: AppRouter

  public init(viewModel: OnboardingViewModel) {
    self._viewModel = ObservedObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        CustomAppBarView(title: Constants.title, page: currentPage)
        
        switch viewModel.state {
          case .idle, .loading, .transitioning:
            ProgressView()
              .frame(maxHeight: .infinity)
            
          case .error(let message):
            VStack {
              Spacer()
              Text(message)
                .foregroundColor(.red)
                .padding()
              Spacer()
            }
            
          case .loaded(let step, let items):
            switch step {
              case .categories:
                OnboardingListView(
                  onboardingCategoriesWithSelection: items.filter {
                    if case .category = $0.item { return true }
                    return false
                  },
                  onItemTapped: viewModel.toggleSelection
                )
                
              case .subcategories:
                SubOnboardingListView(
                    groupedItems: viewModel.groupedItemsByCategory(from: items),
                    onTap: viewModel.toggleSelection
                )
            }
        }
      }
      .frame(maxHeight: .infinity)
      
      if case .loaded(let step, _) = viewModel.state {
        switch step {
          case .categories:
            BottomBarView(
              title: Constants.nextSectionLabel,
              onTapAction: {viewModel.transition(to: .subcategories)}
            )
            
          case .subcategories:
            BottomBarView(
              title: Constants.letsRollMessage,
              showBackButton: true,
              onTapAction: handleStartQuiz,
              onBackAction: { viewModel.transition(to: .categories)}
            )
        }
      }
    }
    .onAppear {
      viewModel.loadOnboardingItems()
    }
  }
  
  private var currentPage: PageType {
    if case .loaded(let step, _) = viewModel.state {
      return step == .categories ? .onboarding : .subOnboarding
    }
    return .onboarding
  }
  
  private func handleStartQuiz() {
    viewModel.sendSelectedItems()
    router.push(.quizGame)
  }
}


private struct OnboardingListView: View {
  let onboardingCategoriesWithSelection: [OnboardingItemWithSelection]
  let onItemTapped: (OnboardingItemWithSelection) -> Void
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: UIConstants.Spacing.card) {
        ForEach(onboardingCategoriesWithSelection) { categoryItemWithSelection in
          CategoryView(itemWithSelection: categoryItemWithSelection) { tappedItem in
            onItemTapped(tappedItem)
          }
        }
      }
      .padding()
    }
  }
}

private struct CategoryView: View {
  let itemWithSelection: OnboardingItemWithSelection
  let onTap: (OnboardingItemWithSelection) -> Void
  
  var body: some View {
    VStack {
      Text(itemWithSelection.item.name)
        .font(.system(size: UIConstants.FontSize.medium))
        .fontWeight(.heavy)
        .foregroundColor(MyColorScheme.darkGreen)
        .padding()
    }
    .frame(maxWidth: .infinity)
    .background(itemWithSelection.isSelected ? MyColorScheme.softYellow : MyColorScheme.transparent)
    .overlay(
      RoundedRectangle(cornerRadius: UIConstants.Radius.large)
        .stroke(itemWithSelection.isSelected ? MyColorScheme.softYellow : MyColorScheme.darkGreen)
    )
    .cornerRadius(UIConstants.Radius.large)
    .onTapGesture {
      onTap(itemWithSelection)
    }
  }
  
}
