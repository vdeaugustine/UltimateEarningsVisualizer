//
//  TodayProgressBar.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayProgressBar: View {
    @ObservedObject var viewModel: TodayViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .background(.white)

                // Progress
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .cornerRadius(8)

                    // MARK: Will pay in taxes

                    Rectangle()
                        .fill(
                            Color(red: 0.77,
                                  green: 0.25,
                                  blue: 0.25).opacity(0.5)
                        )
                        .frame(width: viewModel.wage.totalTaxMultiplier * geo.size.width,
                               height: 22)
                        .cornerRadius(8)

                    // MARK: Taxes Paid

                    Rectangle()
                        .fill(
                            Color(red: 0.77,
                                  green: 0.25,
                                  blue: 0.25)
                        )
                        .frame(width: viewModel.percentForTaxesSoFar * geo.size.width, height: 22)
                        .cornerRadius(8)
                        .hidden()
                    
                    
                    // MARK: Spent
                    
                    Rectangle()
                        .fill(
                            viewModel.settings.themeColor
                        )
                        .frame(width: viewModel.percentPaidSoFar * geo.size.width, height: 22)
                        .cornerRadius(8)
                    
                }
                .frame(height: 22)

                .padding(16)
            }
        }
        .frame(height: 60)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 4)
    }
}

#Preview {
    ZStack {
        Color.targetGray
        TodayProgressBar(viewModel: .main)
            .padding()
    }
}
