//
//  PayoffQueueView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import SwiftUI

// MARK: - PayoffQueueView

struct PayoffQueueView: View {
    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings: Settings = User.main.getSettings()

    @State private var newPayoffQueue: [PayoffItem] = User.main.getQueue()
//    @State private var editMode: EditMode = .inactive

    
    @State private var someArr: [Int] = (0 ... 10).map { $0 }

    var body: some View {
        List {
            ForEach(user.getQueue().indices, id: \.self) { index in

                if let expense = user.getItemWith(queueSlot: index + 1) as? Expense {
                    NavigationLink {
                        ExpenseDetailView(expense: expense)
                    } label: {
                        ExpenseRow(expense: expense)
                    }
                    .buttonStyle(.plain)
                }

                if let goal = user.getItemWith(queueSlot: index + 1) as? Goal {
                    NavigationLink {
                        GoalDetailView(goal: goal)
                    } label: {
                        GoalRow(goal: goal)
                    }
                    .buttonStyle(.plain)
                }
            }
            .onMove(perform: move)
//            .moveDisabled(editMode != .active)
        }
        .listStyle(.plain)
        .navigationTitle("Payoff Queue")
        .putInTemplate()
        .toolbar {
            ToolbarItem {
                EditButton()
            }
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        let preMove = user.getQueue()
        var afterMove = preMove
        afterMove.move(fromOffsets: source, toOffset: destination)

        var counter = 1

        for item in afterMove {
            var payoff = item
            payoff.optionalQSlotNumber = Int16(counter)
            counter += 1
        }

        let expenses = afterMove.compactMap { $0 as? Expense }
        let goals = afterMove.compactMap { $0 as? Goal }

        user.goals = NSSet(array: goals)
        user.expenses = NSSet(array: expenses)

        try! user.managedObjectContext!.save()
    }
}

// MARK: - PayoffQueueView_Previews

struct PayoffQueueView_Previews: PreviewProvider {
    static var previews: some View {
        PayoffQueueView()
            .putInNavView(.inline)
    }
}
