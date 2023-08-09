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

    let distance: CGFloat = 40

    var limit: CGFloat { 800 }

    var minValue: CGFloat {
        min(CGFloat(viewModel.tempPayoffs.count), limit)
    }

    var offsetForStack: CGFloat { 20 }

    var frameWhenStacked: CGFloat { 100 + offsetForStack * minValue }

    var frameWhenFanned: CGFloat { CGFloat(110 * minValue) }

    var totalOffSetWhenFanned: CGFloat { minValue * offsetForStack }

    var zStackHeight: CGFloat { isFannedOut ? frameWhenFanned : frameWhenStacked }

    @State private var isFannedOut = false

    func yPosition(for index: Int) -> CGFloat {
        let firstOffset: CGFloat = 50
        let multiplier: CGFloat = isFannedOut ? 110 : 20
        return firstOffset + multiplier * CGFloat(index)
    }

    var body: some View {
        LazyVStack {
            if viewModel.paidOffStackIsExpanded {
                ForEach(viewModel.nonZeroPayoffItems) { item in
                    TodayViewPaidOffRect(item: item)
                }
            } else {
                if let firstItem = viewModel.nonZeroPayoffItems.first {
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
