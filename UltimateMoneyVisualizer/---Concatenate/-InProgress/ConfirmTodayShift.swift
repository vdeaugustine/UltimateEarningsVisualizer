//
//  ConfirmTodayShift.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/14/23.
//

import SwiftUI
import Vin

// MARK: - ConfirmTodayShift

struct ConfirmTodayShift: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    @State private var paidOffItems: [TempTodayPayoff] = []
    @State private var paidOffGoals: [TempTodayPayoff] = []
    @State private var paidOffExpenses: [TempTodayPayoff] = []

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

    @State private var showExpenses = true
    @State private var showGoals = true
    @State private var showTaxes = true

    var body: some View {
        List {
            if let shift = viewModel.user.todayShift,
               let start = shift.startTime,
               let end = shift.endTime {
                Section("Time") {
                    Text("Start")
                        .spacedOut(text: start.getFormattedDate(format: .minimalTime))
                    Text("End")
                        .spacedOut(text: end.getFormattedDate(format: .minimalTime))
                    Text("Duration")
                        .spacedOut(text: shift.totalShiftDuration.breakDownTime())
                }

                Section("Earnings") {
                    Text("Scheduled to earn")
                        .spacedOut(text: shift.totalWillEarn.money())
                    Text("Total earned")
                        .spacedOut(text: shift.totalEarnedSoFar(.now).money())
                    Text("After taxes")
                        .spacedOut(text: earnedAfterTaxes.money())
                }

                Section("Expenses") {
                    Button {
                        withAnimation {
                            showExpenses.toggle()
                        }
                    } label: {
                        Text("Total")
                            .spacedOut {
                                HStack {
                                    Text(spentOnExpenses.money())
                                    Components.nextPageChevron
                                        .rotationEffect(.degrees(showExpenses ? 90 : 0))
                                }
                            }
                    }
                    .foregroundStyle(Color.black)
                    if showExpenses {
                        ForEach(paidOffExpenses) { expense in
                            Text(expense.title)
                                .spacedOut(text: expense.progressAmount.money())
                                .padding(.leading)
                        }
                    }
                }

                Section("Goals") {
                    Button {
                        withAnimation {
                            showGoals.toggle()
                        }
                    } label: {
                        Text("Total")
                            .spacedOut {
                                HStack {
                                    Text(spentOnGoals.money())
                                    Components.nextPageChevron
                                        .rotationEffect(.degrees(showGoals ? 90 : 0))
                                }
                            }
                    }
                    .foregroundStyle(Color.black)

                    if showGoals {
                        ForEach(paidOffGoals) { goal in
                            Text(goal.title)
                                .spacedOut(text: goal.progressAmount.money())
                                .padding(.leading)
                        }
                        
                    }

                    
                }
                
                Section("Taxes") {
                    
                    Button {
                        withAnimation {
                            showTaxes.toggle()
                        }
                    } label: {
                        Text("Total")
                            .spacedOut {
                                HStack {
                                    Text(spentOnTaxes.money())
                                    Components.nextPageChevron
                                        .rotationEffect(.degrees(showTaxes ? 90 : 0))
                                }
                            }
                            
                    }
                    .foregroundStyle(Color.black)
                    .transition(.slide)
                    
                    if showTaxes {
                        ForEach(paidOffItems.filter { $0.type == .tax }) { item in
                            Text(item.title)
                                .spacedOut(text: item.progressAmount.money())
                                .padding(.leading)
                                .transition(.slide)
                        }
                        
                    }
                }
            }
        }
        
        .background {
            Color.targetGray.ignoresSafeArea()
        }
        .navigationTitle("Confirm Today's Shift")
        .putInTemplate()
        .onAppear(perform: {
            paidOffItems = viewModel.tempPayoffs
            paidOffExpenses = viewModel.expensePayoffItems
            paidOffGoals = viewModel.goalPayoffItems
        })
        .bottomButton(label: "Save") {
            
        }
        
    }

    var payoffSection: some View {
        VStack {
            // MARK: Expenses

            if !paidOffExpenses.isEmpty {
                List {
                    Section {
                        ForEach(paidOffExpenses) { expense in
                            TodayViewPaidOffRect(item: expense)
                        }
                        .onDelete { paidOffExpenses.remove(atOffsets: $0) }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)

                    } header: {
                        HStack {
                            Text("\(paidOffExpenses.count) EXPENSES")
                            Spacer()
                            Text(spentOnExpenses.money())
                        }
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "4E4E4E"))
                    }
                }
                .listStyle(.plain)
                .frame(height: viewModel.getPayoffListsHeight(forCount: paidOffExpenses.count))
            }

            // MARK: Goals

            if !paidOffGoals.isEmpty {
                List {
                    Section {
                        ForEach(paidOffGoals) { goal in
                            TodayViewPaidOffRect(item: goal)
                        }
                        .onDelete { paidOffGoals.remove(atOffsets: $0) }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)

                    } header: {
                        HStack {
                            Text("\(paidOffGoals.count) GOALS")
                            Spacer()
                            Text(spentOnGoals.money())
                        }

                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "4E4E4E"))
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(-10)
                .frame(height: viewModel.getPayoffListsHeight(forCount: paidOffGoals.count))
            }
        }
    }
}

// MARK: - ConfirmTodayShift_Previews

struct ConfirmTodayShift_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmTodayShift()
            .putInNavView(.inline)
            .environmentObject(TodayViewModel.main)
    }
}
