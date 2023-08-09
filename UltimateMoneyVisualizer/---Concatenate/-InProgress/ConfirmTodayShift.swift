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
        paidOffGoals.reduce(Double(0)) { $0 + $1.amountPaidOff }
    }

    var spentOnExpenses: Double {
        paidOffExpenses.reduce(Double(0)) { $0 + $1.amountPaidOff }
    }

    var spentTotal: Double {
        spentOnGoals + spentOnExpenses
    }

    var unspent: Double {
        viewModel.haveEarnedAfterTaxes - spentTotal
    }

    var body: some View {
        ScrollView {
            VStack {
                if let shift = viewModel.user.todayShift,
                   let start = shift.startTime,
                   let end = shift.endTime {
                    VStack(spacing: 8) {
                        Text(Date.timeRangeString(start: start, end: end))
                            .font(.lato(24))
                            .fontWeight(.black)
                        Text(viewModel.elapsedTime.breakDownTime())
                            .font(.lato(18))
                            .fontWeight(.semibold)
                    }

                    HStack {
                        TodayViewInfoRect(imageName: "dollarsign.circle",
                                          valueString: viewModel.haveEarned.money(),
                                          bottomLabel: "Earned")

                        TodayViewInfoRect(imageName: "dollarsign.circle",
                                          valueString: viewModel.haveEarnedAfterTaxes.money(),
                                          bottomLabel: "Taxes")
                    }
                    HStack {
                        TodayViewInfoRect(imageName: "dollarsign.circle",
                                          valueString: spentTotal.money(),
                                          bottomLabel: "Total Spent")

                        TodayViewInfoRect(imageName: "dollarsign.circle",
                                          valueString: unspent.money(),
                                          bottomLabel: "Surplus")
                    }
                }

                payoffSection.padding(.vertical)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        .background {
            Color.targetGray.ignoresSafeArea()
        }
        .safeAreaInset(edge: .top, content: {
            GeometryReader { geo in
                ZStack {
                    Color(hex: "003DFF")

                    HStack {
                        Button {
                            viewModel.navManager.todayViewNavPath.removeLast()
                        } label: {
                            
                                
                                Label("Back", systemImage: "chevron.left")
                                    .labelStyle(.iconOnly)
                                    .background {
                                        Circle()
                                            .fill(Color(hex: "3F63F3"))
                                    }
                            
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()

                        Text("Confirm Today Shift")
                            .font(.lato(22))
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.frame(in: .local).midX,
                              y: geo.frame(in: .local).maxY - 40)
                    
                    
                }
            }
            .frame(height: 125)
            .ignoresSafeArea()
        })
        .navigationBarHidden(true)
        .onAppear(perform: {
            paidOffItems = viewModel.tempPayoffs
            paidOffExpenses = viewModel.expensePayoffItems
            paidOffGoals = viewModel.goalPayoffItems
        })
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
                        .font(.lato(20)).fontWeight(.semibold)
                        .foregroundColor(Color(hex: "4E4E4E"))
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(-10)
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
                        .font(.lato(20)).fontWeight(.semibold)
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
