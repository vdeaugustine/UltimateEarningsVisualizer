//
//  ShiftDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import Charts
import SwiftUI

// MARK: - ShiftDetailView

struct ShiftDetailView: View {
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var user = User.main
    @ObservedObject private var settings = User.main.getSettings()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showEarningsSection = true
    @State private var showTimeBlockSection = true

    var last4Shifts: [Shift] { user.getShifts().prefixArray(4) }

    let shift: Shift

    var payoffItems: [PayoffItem] {
        shift.getPayoffItemsAllocatedTo()
    }

    var allocations: [Allocation] {
        shift.getAllocations().sorted(by: { $0.amount > $1.amount })
    }

    var body: some View {
        List {
            Section {
//                HorizontalDataDisplay(data: [.init(label: "Start", value: shift.start.getFormattedDate(format: .minimalTime), view: nil),
//                                             .init(label: "End", value: shift.end.getFormattedDate(format: .minimalTime), view: nil),
//                                             .init(label: "Duration", value: shift.duration.formatForTime(), view: nil)])
                
                HStack {
                    SystemImageWithFilledBackground(systemName: IconManager.startShift)
                    Text("Start")
                    Spacer()
                    Text(shift.start.getFormattedDate(format: .minimalTime))
                }
                
                HStack {
                    SystemImageWithFilledBackground(systemName: IconManager.endShift)
                    Text("End")
                        .spacedOut(text: shift.end.getFormattedDate(format: .minimalTime))
                }
                
                HStack {
                    SystemImageWithFilledBackground(systemName: IconManager.timeDuration)
                    Text("Duration")
                        .spacedOut(text: shift.duration.formatForTime())
                }
                    
            } header: {
                Text("Hours")
            }

            Section("Earnings") {
                if showEarningsSection {
                    HStack {
                        SystemImageWithFilledBackground(systemName: IconManager.earningsIncreased, backgroundColor: Components.unspentColor)
                        Text("Earnings")
                            .spacedOut {
                                Text(shift.totalEarned.money())
                            }
                    }

                    HStack {
                        SystemImageWithFilledBackground(systemName: IconManager.earningsDecreased, backgroundColor: .niceRed)
                        Text("Spent")
                            .spacedOut {
                                Text(shift.totalAllocated.money())
                            }
                    }

                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign.arrow.circlepath", backgroundColor: Components.unspentColor)
                        Text("Available")
                            .spacedOut {
                                Text(shift.totalAvailable.money())
                            }
                    }
                }
            }
//            .listRowSeparator(.hidden)

            Section {
                GPTPieChart(pieChartData: [.init(color: Components.taxesColor, name: "Taxes", amount: shift.taxesPaid),
                                           .init(color: Components.goalsColor, name: "Goals", amount: shift.allocatedToGoals),
                                           .init(color: Components.expensesColor, name: "Expenses", amount: shift.allocatedToExpenses),
                                           .init(color: Components.unspentColor, name: "Available", amount: shift.totalAvailable)])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .frame(height: 200)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Section("Time Blocks") {
                if showTimeBlockSection {
                    ItemizedPartOfShiftView(shift: shift)
                        .padding(.vertical)
                }
            }
            Section("Allocations") {
                ForEach(allocations) { alloc in

                    Button {
                        NavManager.shared.appendCorrectPath(newValue: .allocationDetail(alloc))

                    } label: {
                        if let goal = alloc.goal {
                            HStack {
                                Image(systemName: IconManager.goalsString)

                                Text(goal.titleStr)
                                    .spacedOut(text: alloc.amount.money())
                                
                                Components.nextPageChevron
                            }
                        }

                        if let expense = alloc.expense {
                            HStack {
                                Image(systemName: IconManager.expenseString)

                                Text(expense.titleStr)
                                    .spacedOut(text: alloc.amount.money())
                                
                                Components.nextPageChevron
                            }
                        }
                    }
                    .foregroundStyle(Color.black)
                }
            }

//            Button("Delete", role: .destructive) {
//                showDeleteConfirmation = true
//            }
        }
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteConfirmation.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .background(Color.listBackgroundColor)
        .putInTemplate()
        .navigationTitle("Shift for \(shift.start.getFormattedDate(format: .abbreviatedMonth))")
        .confirmationDialog("Are you sure you want to delete this shift?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                deleteAction()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone")
        }
    }

    func deleteAction() {
        user.removeFromShifts(shift)
        viewContext.delete(shift)

        do {
            try viewContext.save()
        } catch {
            print("Error saving after delete", error)
        }

        dismiss()
    }

//    var chart: some View {
//        Chart {
//            ForEach(last4Shifts) { shift in
//                BarMark(x: .value("Date",
//                                  shift == self.shift ? "Today" : shift.startTime.getFormattedDate(format: .monthDay)),
//
//                        y: .value("Duration", shift.durat))
//                .foregroundStyle(shift == self.shift ? .red : settings.themeColor)
//            }
//
//            RuleMark(y: .value("Average", Double(6 * 60 * 60).formatForTime()))
//        }
//        .padding()
//    }
}

// MARK: - ShiftDetailView_Previews

struct ShiftDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftDetailView(shift: User.main.getShifts().first!)
            .putInNavView(.large)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
