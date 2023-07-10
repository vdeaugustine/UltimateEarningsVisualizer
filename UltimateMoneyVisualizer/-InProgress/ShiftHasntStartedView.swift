//
//  ShiftHasntStartedView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import SwiftUI

// MARK: - ShiftHasntStartedView

struct ShiftHasntStartedView: View {
    @ObservedObject var viewModel: TodayViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            VStack(spacing: 70) {
                VStack {
                    Text("Shift Start")
                        .font(.largeTitle)

                    Text(viewModel.start.getFormattedDate(format: .minimalTime))
                        .font(.title2)
                }

                Text(viewModel.timeUntilShiftString())
                    .font(.system(size: 50))
                    .fontWeight(.bold)
            }
        }
        .onReceive(timer) { _ in
            viewModel.nowTime = Date.now
        }
    }
}

// MARK: - ShiftHasntStartedView_Previews

struct ShiftHasntStartedView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftHasntStartedView(viewModel: TodayViewModel.main)
    }
}
