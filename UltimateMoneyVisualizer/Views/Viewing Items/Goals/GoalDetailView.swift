//
//  GoalDetailView.swift
//  UltimateGoalVisualizer
//
//  Created by ChatGPT on 4/26/23.
//

import SwiftUI

// MARK: - GoalDetailView

struct GoalDetailView: View {
    var goal: Goal

    var body: some View {
        VStack {
            Text(goal.title ?? "")
                .font(.largeTitle)
            Text("\(goal.amount)")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(goal.info ?? "")
                .font(.body)
        }
        .navigationTitle("Goal Detail")
    }
}

// MARK: - GoalDetailView_Previews

struct GoalDetailView_Previews: PreviewProvider {
    static let context = PersistenceController.context

    static let goal: Goal = {
        let goal = Goal(context: context)

        goal.title = "Test goal"
        goal.amount = 1000
        goal.info = "this is a test description"
        goal.dateCreated = Date()

        return goal
    }()

    static var previews: some View {
        GoalDetailView(goal: goal)
    }
}
