//
//  NewTodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct NewTodayView: View {
    @ObservedObject var viewModel: TodayViewModel = .main
    var body: some View {
        ScrollView {
            VStack {
                headerAndBar
                Spacer()
                    .frame(height: 24)
                TodayViewInfoRects(viewModel: viewModel)
                    .padding(.horizontal)
                    
            }
            
        }
        .ignoresSafeArea()
        .background(Color.targetGray)
        .onReceive(viewModel.timer) { _ in
            viewModel.addSecond()
        }
    }

    var headerAndBar: some View {
        VStack(spacing: -30) {
            TodayViewHeader()
            TodayViewProgressBarAndLabels(viewModel: viewModel)
                .padding(.horizontal)
        }
    }

    var infoRects: some View {
        HStack {
            TodayViewInfoRect(imageName: "hourglass", valueString: viewModel.remainingTime.breakDownTime(), bottomLabel: "Remaining")
        }
    }
}

#Preview {
    NewTodayView()
}
