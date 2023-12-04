//
//  TodayPaidOffStackWithHeader.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayPaidOffStackWithHeader

struct TodayPaidOffStackWithHeader: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    var bottomButtonText: String {
        viewModel.paidOffStackIsExpanded ? "Collapse" : "Expand"
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("PAID OFF TODAY")

                Spacer()

                Button {
                    viewModel.navManager.appendCorrectPath(newValue: .todayViewPayoffQueue)

                } label: {
                    Label("More", systemImage: "ellipsis")
                        .labelStyle(.iconOnly)
                }
            }
            .font(.callout)
            .fontWeight(.semibold)
//            .tracking(1)
            .foregroundStyle(Color(hex: "4E4E4E"))

            TodayPaidOffStack()

            Button(bottomButtonText) {
                viewModel.paidOffStackIsExpanded.toggle()
            }
            .padding(.top)
        }
//        .animation(.none, value: viewModel.paidOffStackIsExpanded)
    }
}

// MARK: - TodayPaidOffStackWithHeader_Previews

struct TodayPaidOffStackWithHeader_Previews: PreviewProvider {
    static var previews: some View {
        TodayPaidOffStackWithHeader()
            .environmentObject(TodayViewModel.main)
    }
}
