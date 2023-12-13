//
//  TodayPaidOffStack.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayPaidOffStack

struct TodayPaidOffStack: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    var body: some View {
        LazyVStack {
            if viewModel.paidOffStackIsExpanded {
                ForEach(viewModel.nonZeroPayoffItems.reversed()) { item in
                    TodayViewPaidOffRect(item: item)
                }
            } else {
                if let firstItem = viewModel.nonZeroPayoffItems.last {
                    TodayViewPaidOffRect(item: firstItem)
                }
            }
        }
    }
}

// MARK: - TodayPaidOffStack_Previews

struct TodayPaidOffStack_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.targetGray
            TodayPaidOffStack()
        }
        .environmentObject(TodayViewModel.main)
    }
}
