//
//  PayoffQueueForTodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/16/23.
//

import SwiftUI

// MARK: - PayoffQueueForTodayView

struct PayoffQueueForTodayView: View {
    @ObservedObject var vm: TodayViewModel = .main

    @Environment(\.editMode) private var editMode

    @State private var queue: [TempTodayPayoff] = TodayViewModel.main.tempPayoffs

    @State private var showSelectionView = false // Add this state variable

    var body: some View {
        List {
            ForEach(vm.tempPayoffs) { item in
                TodayViewPaidOffRect(item: item)
                    .environmentObject(vm)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.grouped)
        .background {
            Color.listBackgroundColor
        }
        .navigationTitle("Payoff Item Queue")
        .toolbar {
            ToolbarItem {
                EditButton()
                    .foregroundStyle(.white)
            }

            ToolbarItem(placement: .navigationBarTrailing) { // Add this toolbar item
                Button(action: {
                    showSelectionView.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .foregroundStyle(.white)
            }
        }
        .onReceive(vm.timer) { _ in
            vm.addSecond()
        }
        .putInTemplate()
        .sheet(isPresented: $showSelectionView) { // Add this sheet
            SelectionView()
        }
    }
}

// MARK: - SelectionView

struct SelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Goal.title, ascending: true)], animation: .default)
    private var goals: FetchedResults<Goal>

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Expense.title, ascending: true)], animation: .default)
    private var expenses: FetchedResults<Expense>

    @State private var selectedGoals: Set<Goal> = []
    @State private var selectedExpenses: Set<Expense> = []

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Goals")) {
                    ForEach(goals) { goal in
                        Button(action: {
                            toggleSelection(for: goal)
                        }) {
                            HStack {
                                Text(goal.title ?? "")
                                Spacer()
                                if selectedGoals.contains(goal) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Expenses")) {
                    ForEach(expenses) { expense in
                        Button(action: {
                            toggleSelection(for: expense)
                        }) {
                            HStack {
                                Text(expense.title ?? "")
                                Spacer()
                                if selectedExpenses.contains(expense) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            .putInTemplate(title: "Selection")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { // Add this toolbar item
                    Button(action: saveSelection) {
                        Image(systemName: "Save")
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }

    private func toggleSelection(for goal: Goal) {
        if selectedGoals.contains(goal) {
            selectedGoals.remove(goal)
        } else {
            selectedGoals.insert(goal)
        }
    }

    private func toggleSelection(for expense: Expense) {
        if selectedExpenses.contains(expense) {
            selectedExpenses.remove(expense)
        } else {
            selectedExpenses.insert(expense)
        }
    }

    private func saveSelection() {
        // Perform any necessary actions with the selected goals and expenses
        // For example, you can update the PayoffQueueForTodayView's queue with the selected items
    }
}

// MARK: - PayoffQueueForTodayView_Previews

struct PayoffQueueForTodayView_Previews: PreviewProvider {
    static var previews: some View {
        PayoffQueueForTodayView(vm: TodayViewModel.main)
            .templateForPreview()
            .environmentObject(TodayViewModel.main)
    }
}
