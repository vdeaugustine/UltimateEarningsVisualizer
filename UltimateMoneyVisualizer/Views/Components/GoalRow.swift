//
//  GoalRow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import SwiftUI

struct GoalRow: View {
    let goal: Goal
    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings: Settings = User.main.getSettings()
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text(goal.titleStr)
                    .font(.headline)
                    .foregroundStyle(settings.getDefaultGradient())
                    .pushLeft()

                HStack(alignment: .bottom, spacing: 5) {
                    Text(goal.amountMoneyStr)
                    Spacer()
                    Text("GOAL")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 4)

                VStack {
                    VStack(spacing: 1) {
                        Text("Paid off")
                            .font(.caption2)
                            .spacedOut {
                                Text(goal.amountPaidOff.formattedForMoney())
                                    .font(.caption2)
                            }
                        ProgressBar(percentage: goal.percentPaidOff, color: settings.themeColor)
                    }

                    VStack(spacing: 1) {
                        Text("Remaining")
                            .font(.caption2)
                            .spacedOut {
                                Text(goal.timeRemaining.formatForTime([.year, .day, .hour, .minute]))
                                    .font(.caption2)
                            }
                    }
                }
                .padding(.top)
                .pushTop(alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)

            HStack {
                VStack {
                    Image("disneyworld")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //                            .clipShape(Circle())
                        //                            .height(90)
                        .frame(width: 150)
                        .cornerRadius(8)

                    if let dueDate = goal.dueDate {
                        Text(dueDate.getFormattedDate(format: .abreviatedMonth))
                            .font(.caption).foregroundColor(Color.hexStringToColor(hex: "8E8E93"))
                    }
                }
                .padding(.horizontal)
            }
        }
        .allPartsTappable()
    }
}

struct GoalRow_Previews: PreviewProvider {
    static var previews: some View {
        GoalRow(goal: User.main.getGoals().first!)
            .previewLayout(.sizeThatFits)
    }
}
