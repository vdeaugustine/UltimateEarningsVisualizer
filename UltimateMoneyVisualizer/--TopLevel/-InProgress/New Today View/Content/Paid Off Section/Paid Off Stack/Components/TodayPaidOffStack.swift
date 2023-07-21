//
//  TodayPaidOffStack.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayPaidOffStack: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    let distance: CGFloat = 40
    var body: some View {
        VStack {
            ZStack {
                if let topItem = viewModel.tempPayoffs.first {
                    TodayPaidOffRectContainer()
                    TodayPaidOffRectContainer()
                        .padding(.bottom, distance)
                    TodayViewPaidOffRect(item: topItem)
                        .padding(.bottom, distance * 2)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.targetGray
        TodayPaidOffStack()
    }
    .environmentObject(TodayViewModel.main)
}
