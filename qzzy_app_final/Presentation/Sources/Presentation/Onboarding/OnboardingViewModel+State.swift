//
//  OnboardingViewModel+State.swift
//  Presentation
//
//  Created by Veselin Lazarevic on 17. 6. 2025..
//

import Domain

public enum OnboardingStep {
  case categories
  case subcategories
}

public enum OnboardingViewState {
  case idle
  case loading
  case transitioning(to: OnboardingStep, from: OnboardingStep, items: [OnboardingItemWithSelection])
  case loaded(step: OnboardingStep, items: [OnboardingItemWithSelection])
  case error(String)
}
