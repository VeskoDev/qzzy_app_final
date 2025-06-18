//
//  SwiftUIView.swift
//  
//
//  Created by Veselin Lazarevic on 7.5.25..
//

import SwiftUI
import Domain


public struct SubOnboardingListView: View {
    let groupedItems: [(OnboardingCategory, [OnboardingItemWithSelection])]
    let onTap: (OnboardingItemWithSelection) -> Void

    public init(
        groupedItems: [(OnboardingCategory, [OnboardingItemWithSelection])],
        onTap: @escaping (OnboardingItemWithSelection) -> Void
    ) {
        self.groupedItems = groupedItems
        self.onTap = onTap
    }

    public var body: some View {
        ScrollView (showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(groupedItems, id: \.0.id) { (category, countries) in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.name)
                            .font(.system(size: 38, weight: .thin))
                            .foregroundColor(MyColorScheme.darkGreen)

                        let rows = split(countries)
                        ForEach(0..<rows.count, id: \.self) { rowIndex in
                            let row = rows[rowIndex]
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(row) { item in
                                        CountryChipView(itemWithSelection: item, onTap: onTap)
                                    }
                                }
                               
                            }
                        }
                    }
                }
              Spacer().frame(height: 48)
            }
            .padding(.leading)
        }
    }

    private func split(_ items: [OnboardingItemWithSelection]) -> [[OnboardingItemWithSelection]] {
        guard !items.isEmpty else { return [[]] }
        let mid = max(1, items.count / 2)
        return [Array(items.prefix(mid)), Array(items.suffix(from: mid))]
    }
}
private struct CountryChipView: View {
    let itemWithSelection: OnboardingItemWithSelection
    let onTap: (OnboardingItemWithSelection) -> Void

    var body: some View {
        VStack {
            Text(itemWithSelection.item.name)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(MyColorScheme.darkGreen)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(itemWithSelection.isSelected ? MyColorScheme.softYellow : MyColorScheme.transparent)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(itemWithSelection.isSelected ? MyColorScheme.softYellow : MyColorScheme.darkGreen)
        )
        .cornerRadius(30)
        .onTapGesture {
            onTap(itemWithSelection)
        }
    }
}
