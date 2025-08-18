//
//  ConfirmTodayShift.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/14/23.
//

import SwiftUI
import Vin

// MARK: - ConfirmTodayShift_UseThisOne

struct ConfirmTodayShift_UseThisOne: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    @Environment(\.dependencies) private var deps
    @State private var paidOffItems: [TempTodayPayoff] = []
    @State private var paidOffGoals: [TempTodayPayoff] = []
    @State private var paidOffExpenses: [TempTodayPayoff] = []
    
    @State private var newAllocations: [Allocation] = []
    
    @State private var newShift: Shift? = nil

    var spentOnGoals: Double {
        paidOffGoals.reduce(Double(0)) { $0 + $1.progressAmount }
    }

    var spentOnExpenses: Double {
        paidOffExpenses.reduce(Double(0)) { $0 + $1.progressAmount }
    }

    var spentOnTaxes: Double {
        let taxes = paidOffItems.filter { $0.type == .tax }
        return taxes.reduce(Double.zero) { $0 + $1.progressAmount }
    }

    var spentTotal: Double {
        spentOnGoals + spentOnExpenses + spentOnTaxes
    }

    var unspent: Double {
        viewModel.haveEarnedAfterTaxes - spentTotal
    }

    var earnedAfterTaxes: Double {
        viewModel.haveEarned - spentOnTaxes
    }

    @State private var showExpenses = false
    @State private var showGoals = false
    @State private var showTaxes = false

    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    private var newAllocationAmount: Double {
        newAllocations.reduce(Double.zero) { partialResult, newAlloc in
            partialResult + newAlloc.amount
        }
    }

    var body: some View {
        content
    }

    @ViewBuilder private var content: some View {
        List {
            if let shift = viewModel.user.todayShift {
                timeSection(shift: shift)
                earningsSection(shift: shift)
                expensesSection()
                goalsSection()
                taxesSection()
            }
        }
        .background { Color.targetGray.ignoresSafeArea() }
        .navigationTitle("Confirm Today's Shift")
        .putInTemplate()
        .onAppear(perform: onAppearLoad)
        .bottomButton(label: "Save", action: saveButtonAction)
        .alert("Successfully saved new allocations", isPresented: $showSuccessAlert, actions: successActions, message: successMessage)
        .alert("Error saving.", isPresented: $showErrorAlert, actions: errorActions, message: errorMessageView)
    }

    // MARK: - Sections

    @ViewBuilder private func timeSection(shift: TodayShift) -> some View {
        if let start = shift.startTime, let end = shift.endTime {
            Section("Time") {
                Text("Start").spacedOut(text: start.getFormattedDate(format: .minimalTime))
                Text("End").spacedOut(text: end.getFormattedDate(format: .minimalTime))
                Text("Duration").spacedOut(text: shift.totalShiftDuration.breakDownTime())
            }
        }
    }

    @ViewBuilder private func earningsSection(shift: TodayShift) -> some View {
        Section("Earnings") {
            Text("Scheduled to earn").spacedOut(text: shift.totalWillEarn.money())
            Text("Total earned").spacedOut(text: shift.totalEarnedSoFar(.now).money())
            Text("After taxes").spacedOut(text: earnedAfterTaxes.money())
        }
    }

    @ViewBuilder private func expensesSection() -> some View {
        Section("Expenses") {
            DisclosureGroup(isExpanded: $showExpenses) {
                ForEach(paidOffExpenses) { expense in
                    Text(expense.title)
                        .spacedOut(text: expense.progressAmount.money())
                        .padding(.leading)
                }
                .onDelete { indexSet in paidOffExpenses.remove(atOffsets: indexSet) }
            } label: {
                Text("Total").spacedOut(text: spentOnExpenses.money())
            }
        }
    }

    @ViewBuilder private func goalsSection() -> some View {
        Section("Goals") {
            DisclosureGroup(isExpanded: $showGoals) {
                ForEach(paidOffGoals) { goal in
                    Text(goal.title)
                        .spacedOut(text: goal.progressAmount.money())
                        .padding(.leading)
                }
                .onDelete { indexSet in paidOffGoals.remove(atOffsets: indexSet) }
            } label: {
                Text("Total").spacedOut(text: spentOnGoals.money())
            }
        }
    }

    @ViewBuilder private func taxesSection() -> some View {
        Section("Taxes") {
            DisclosureGroup(isExpanded: $showTaxes) {
                ForEach(paidOffItems.filter { $0.type == .tax }) { item in
                    Text(item.title)
                        .spacedOut(text: item.progressAmount.money())
                        .padding(.leading)
                }
                .onDelete { indexSet in paidOffItems.remove(atOffsets: indexSet) }
            } label: {
                Text("Total").spacedOut(text: spentOnTaxes.money())
            }
        }
    }

    // MARK: - Alerts

    private func successActions() -> some View {
        Button("Great!", action: handleSuccess)
    }

    private func successMessage() -> some View {
        Text("\(newAllocations.count) were created for a total of \(newAllocationAmount.money())")
    }

    private func errorActions() -> some View {
        Group {
            Button("Try again", action: saveButtonAction)
            Button("Go back", role: .cancel) { showErrorAlert = false }
        }
    }

    private func errorMessageView() -> some View {
        Text(errorMessage)
    }

    // MARK: - Lifecycle

    private func onAppearLoad() {
        paidOffItems = viewModel.tempPayoffs.filter { $0.progressAmount >= 0.01 }
        paidOffExpenses = viewModel.expensePayoffItems.filter { $0.progressAmount >= 0.01 }
        paidOffGoals = viewModel.goalPayoffItems.filter { $0.progressAmount >= 0.01 }
    }

    // MARK: - Actions

    private func handleSuccess() {
        guard let newShift else { return }
        viewModel.user.todayShift = nil
        try? viewModel.viewContext.save()
        deps.navigator.clear()
        deps.navigator.currentTab = .allItems
        deps.navigator.push(.shift(newShift))
    }
    
    private func saveButtonAction() {
        do {
           (newShift, newAllocations) = try viewModel.tappedSaveOnConfirmShiftView(goals: paidOffGoals, expenses: paidOffExpenses)
            showSuccessAlert = true
            
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}

// MARK: - ConfirmTodayShift_Previews

struct ConfirmTodayShift_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmTodayShift_UseThisOne()
            .putInNavView(.inline)
            .environmentObject(TodayViewModel.main)
    }
}
