//
//  GoalListView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

// MARK: - GoalListView

struct GoalListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Goal.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Goal.dateCreated, ascending: false)]) private var goals: FetchedResults<Goal>

    var body: some View {
        List {
            ForEach(goals, id: \.self) { goal in
                NavigationLink(destination: GoalDetailView(goal: goal)) {
                    VStack(alignment: .leading) {
                        Text(goal.title ?? "")
                            .font(.headline)
                        Text("\(goal.amount)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Goals")
    }
}

// MARK: - GoalListView_Previews

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalListView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInTemplate()
            .putInNavView(.inline)
    }
}

