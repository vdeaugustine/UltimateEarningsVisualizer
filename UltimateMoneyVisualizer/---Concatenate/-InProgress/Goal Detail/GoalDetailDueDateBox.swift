//
//  GoalDetailDueDateBox.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import SwiftUI

// MARK: - GoalDetailDueDateBox

struct GoalDetailDueDateBox: View {
    @ObservedObject var viewModel: GoalDetailViewModel
    

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "hourglass")
                    .font(.title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }
            .layoutPriority(0)
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.breakDownTime())
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxHeight: .infinity)
                    .layoutPriority(2)
                    .minimumScaleFactor(0.4)

                HStack {
                    if let dueDate = viewModel.goal.dueDate {
                        Text("Remaining")
                        Spacer()
                        Text(dueDate.getFormattedDate(format: .slashDate))
                    } else {
                        Text("Set due date")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color.gray)
                .layoutPriority(1)
                .minimumScaleFactor(0.85)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
        .frame(minWidth: 175)
        .frame(height: 120)
    }
}

// MARK: - GoalDetailDueDateBox_Previews

struct GoalDetailDueDateBox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.listBackgroundColor
            GoalDetailDueDateBox(viewModel: GoalDetailViewModel(goal: User.main.getGoals()
                    .sorted(by: { $0.timeRemaining > $1.timeRemaining })
                    .last!))
        }
        .ignoresSafeArea()
    }
}
