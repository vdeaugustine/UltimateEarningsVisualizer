//
//  GoalDetailProgressBox.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import SwiftUI
import Vin

// MARK: - GoalDetailProgressBox

struct GoalDetailProgressBox: View {
    @ObservedObject var viewModel: GoalDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Progress")
                        .fontWeight(.semibold)
                    Text([viewModel.goal.getAllocations().count.str,
                          "contributions"])
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }

            VStack (alignment: .leading, spacing: 25) {
                HStack {
                    batteryImage

                    VStack(alignment: .center) {
                        Text(viewModel.goal.amountPaidOff.formattedForMoneyExtended(decimalPlaces: 2))
                            .fontWeight(.semibold)
                            .font(.title2)
                            .minimumScaleFactor(0.90)
                            
                        Divider()
                        HStack(alignment: .bottom) {
                            Text([(viewModel.goal.percentPaidOff * 100).simpleStr(), "%"])
                                .fontWeight(.semibold)
                                .layoutPriority(1)
                                
                                
                                
                        }
                        .padding(.top, 5)
                    }
                }
                
                Text(viewModel.goal.amountRemainingToPayOff.formattedForMoney() + " remaining")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
        .frame(width: 175, height: 225)
    }

    var batteryImage: some View {
        VStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "E7E7E7"))
                .frame(width: 35, height: 7)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "E7E7E7"))
                    .frame(width: 50, height: 75)

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "389975"))
                    .frame(width: 50, height: 75 * viewModel.goal.percentPaidOff)
            }
        }
    }
}

// MARK: - GoalDetailProgressBox_Previews

struct GoalDetailProgressBox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.listBackgroundColor
            GoalDetailProgressBox(viewModel: GoalDetailViewModel(goal: User.main.getGoals().first!))
                
        }
        .ignoresSafeArea()
    }
}
