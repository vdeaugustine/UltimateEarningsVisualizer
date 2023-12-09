//
//  HomeViewTotalsContent.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/8/23.
//

import SwiftUI

// MARK: - TotalsToDate_HomeView

struct HomeViewTotalsContent: View {
    static let fixedSize: CGFloat = 100
    // Define the grid layout
    let layout = [GridItem(.fixed(fixedSize)),
                  GridItem(.fixed(fixedSize)),
                  GridItem(.fixed(fixedSize))]

    var body: some View {
        VStack(spacing: 40) {
            TodayViewTotalsHeaderView()
            LazyVGrid(columns: layout, alignment: .center, spacing: 16) {
                HomeViewTotalsItemView(type: .earned)
                HomeViewTotalsItemView(type: .paidOff)
                HomeViewTotalsItemView(type: .taxes)
                HomeViewTotalsItemView(type: .expenses)
                HomeViewTotalsItemView(type: .goals)
                HomeViewTotalsItemView(type: .saved)
            }
            .frame(alignment: .center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeViewTotalsContent()
        .environmentObject(NewHomeViewModel.shared)
}
