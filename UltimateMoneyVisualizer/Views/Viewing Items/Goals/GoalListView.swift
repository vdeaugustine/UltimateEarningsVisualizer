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
            ForEach(goals) { goal in
                NavigationLink(destination: GoalDetailView(goal: goal)) {
                    

                    GradientOverlayView(goal: goal, maxHeight: 100)
//                        GoalRow(goal: goal)
                    
                }
            }
            .listRowBackground(Color.listBackgroundColor)
        }
        .putInTemplate()
        .navigationTitle("Goals")
        .toolbarAdd {
            CreateGoalView()
        }
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

