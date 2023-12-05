//
//  PayoffQueueView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import AlertToast
import SwiftUI

// MARK: - PayoffQueueView

struct PayoffQueueView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings: Settings = User.main.getSettings()

    @State private var newPayoffQueue: [PayoffItem] = User.main.getQueue()

    @State private var goalToDelete: Goal? = nil
    @State private var expenseToDelete: Expense? = nil

    @State private var showGoalDeleteConformation = false
    @State private var showExpenseDeleteConformation = false

    @State private var showDeleteError = false
    @State private var deleteErrorString = ""
    @State private var queue = User.main.getQueue()

    var body: some View {
        List {
            ForEach(queue.indices, id: \.self) { index in

                if let expense = user.getItemWith(queueSlot: index + 1) as? Expense {
                    Button {
                        NavManager.shared.appendCorrectPath(newValue: .expense(expense))
                    } label: {
                        PayoffItemRectGeneral(item: expense)
                    }
                    .buttonStyle(.plain)
//                    .contextMenu(menuItems: {
//                        Button("Delete", role: .destructive) {
//                            expenseToDelete = expense
//                            showExpenseDeleteConformation.toggle()
//                        }
//                    })
                }

                if let goal = user.getItemWith(queueSlot: index + 1) as? Goal {
                    Button {
                        NavManager.shared.appendCorrectPath(newValue: .goal(goal))
                    } label: {
                        PayoffItemRectGeneral(item: goal)
                    }
                    .buttonStyle(.plain)
                }
            }
            .onMove(perform: move)
            .onDelete { indexSet in
                do {
                    for item in indexSet {
                        if let expense = queue.safeGet(at: item) as? Goal {
                            viewContext.delete(expense)
                            try viewContext.save()
                        }

                        if let goal = queue.safeGet(at: item) as? Expense {
                            viewContext.delete(goal)
                            try viewContext.save()
                        }
                    }
                } catch {
                    showDeleteError.toggle()
                    deleteErrorString = error.localizedDescription
                }
            }
        }

        .listStyle(.plain)
        .navigationTitle("Payoff Queue")
        .putInTemplate()
        .toolbar {
            ToolbarItem {
                EditButton()
            }
        }
        .toast(isPresenting: $showDeleteError, alert: {
            .errorWith(message: "Could not delete")
        })
        .confirmationDialog("Delete \(goalToDelete?.titleStr ?? "")?", isPresented: $showGoalDeleteConformation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                guard let goalToDelete else { return }

                do {
                    viewContext.delete(goalToDelete)
                    try viewContext.save()
                } catch {
                    print("Error saving after delete")
                }
            }
            Button("Cancel", role: .cancel) {
                goalToDelete = nil
            }
        }
        .confirmationDialog("Delete \(expenseToDelete?.titleStr ?? "")?", isPresented: $showExpenseDeleteConformation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                guard let expenseToDelete else { return }
                viewContext.delete(expenseToDelete)
                do {
                    try viewContext.save()
                    print("success deleting!")
                } catch {
                    deleteErrorString = error.localizedDescription
                    showDeleteError = true
                }
            }
            Button("Cancel", role: .cancel) {
                expenseToDelete = nil
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

        TodayViewModel.main.updateInitialPayoffs()
    }
}

// MARK: - PayoffQueueView_Previews

struct PayoffQueueView_Previews: PreviewProvider {
    static var previews: some View {
        PayoffQueueView()
            .putInNavView(.inline)
    }
}
