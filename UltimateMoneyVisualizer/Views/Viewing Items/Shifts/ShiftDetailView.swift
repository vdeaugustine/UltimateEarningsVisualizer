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

    var last4Shifts: [Shift] { user.getShifts().prefixArray(4) }

    let shift: Shift

    var payoffItems: [PayoffItem] {
        shift.getPayoffItemsAllocatedTo()
    }
    
    var allocations: [Allocation] {
        shift.getAllocations().sorted(by: { $0.amount > $1.amount })
    }

    var body: some View {
        VStack {
            List {
                HorizontalDataDisplay(data: [.init(label: "Start", value: shift.start.getFormattedDate(format: .minimalTime), view: nil),
                                             .init(label: "End", value: shift.end.getFormattedDate(format: .minimalTime), view: nil),
                                             .init(label: "Duration", value: shift.duration.formatForTime(), view: nil)])
                    .listRowBackground(Color.clear)

                Section {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "chart.line.uptrend.xyaxis", backgroundColor: settings.themeColor)
                        Text("Earnings")
                            .spacedOut {
                                Text(shift.totalEarned.formattedForMoney())
                            }
                    }

                    HStack {
                        SystemImageWithFilledBackground(systemName: "chart.line.downtrend.xyaxis", backgroundColor: .niceRed)
                        Text("Spent")
                            .spacedOut {
                                Text(shift.totalAllocated.formattedForMoney())
                            }
                    }
                    
                    
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign.arrow.circlepath", backgroundColor: .okGreen)
                        Text("Available")
                            .spacedOut {
                                Text(shift.totalAvailable.formattedForMoney())
                            }
                    }
                    
                    
                }

                Section("Allocations") {
                    ForEach(allocations) { alloc in

                        NavigationLink {
                            AllocationDetailView(allocation: alloc)
                            
                            
                        } label: {
                            if let goal = alloc.goal {
                                HStack {
                                    SystemImageWithFilledBackground(systemName: "target", backgroundColor: settings.themeColor)

                                    Text(goal.titleStr)
                                        .spacedOut(text: alloc.amount.formattedForMoney())
                                }
                            }

                            if let expense = alloc.expense {
                                HStack {
                                    SystemImageWithFilledBackground(systemName: "creditcard.fill", backgroundColor: settings.themeColor)

                                    Text(expense.titleStr)
                                        .spacedOut(text: alloc.amount.formattedForMoney())
                                }
                            }
                        }

//                        HStack {
//
//                            if let goal = alloc.goal {
//                                HStack {
//                                    SystemImageWithFilledBackground(systemName: "target", backgroundColor: settings.themeColor)
//
//                                    Text(goal.titleStr)
//                                        .spacedOut(text: alloc.amount.formattedForMoney())
//                                }
//                            }
//
//                            if let expense = alloc.expense {
//                                SystemImageWithFilledBackground(systemName: "creditcard.fill", backgroundColor: settings.themeColor)
//
//                                Text(expense.titleStr)
//                                    .spacedOut(text: alloc.amount.formattedForMoney())
//                            }
//
//                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .padding(.bottom, 15)
        }
        .padding(.bottom)
        .bottomButton(label: "Delete", action: {
            showDeleteConfirmation = true
        })
        
        .background(Color.targetGray)
        .putInTemplate()
        .navigationTitle("Shift for \(shift.start.getFormattedDate(format: .abreviatedMonth))")
        .confirmationDialog("Are you sure you want to delete this shift?", isPresented: $showDeleteConfirmation) {
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
        ShiftDetailView(shift: User.main.getShifts().last!)
            .putInNavView(.large)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
