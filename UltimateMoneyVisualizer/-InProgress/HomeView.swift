//
//  HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main
    
    @State private var currentPayoffQueueSlot: Int = 1

    var body: some View {
        ZStack {
            ScrollView {
                // MARK: - Lifetime Money

                VStack {
                    HStack {
                        Text("Lifetime")
                            .font(.headline)
                        Spacer()
                        NavigationLink {
                        } label: {
                            Text("Stats")
                                .font(.subheadline)
                                .padding(.trailing)
                        }
                    }

                    NavigationLink {
                        ShiftListView()
                    } label: {
                        HorizontalDataDisplay(data: [.init(label: "earnings", value: user.totalEarned().formattedForMoney()),
                                                     .init(label: "time worked", value: user.totalWorked().formatForTime()),
                                                     .init(label: "time saved", value: user.totalTimeSaved().formatForTime())])
                            .centerInParentView()
                    }
                    .buttonStyle(.plain)
                }
                .padding()

                // MARK: - Total Money Chart

                newSection(header: "Total Money") {
                    VStack {
                        Text("Chart will go here")
                    }
                    .frame(height: 300)
                }
                .padding()

                // MARK: - Current Payoff Item Section

                ScrollView(.horizontal){
                    HStack {
                        if let expense = user.getItemInPayoffQueue(at: currentPayoffQueueSlot) as? Expense {
                            
                            
                            
                            
                            
                        }

                        if let goal = user.getItemInPayoffQueue(at: currentPayoffQueueSlot) as? Goal {
                            
                            goalSection(goal: goal)
                            
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.targetGray)

//        List {
//            Text("Wage")
//                .spacedOut(text: user.wage?.amount.formattedForMoney() ?? "NA")
//            Text("Total Worked")
//                .spacedOut(text: Shift.totalDuration(for: user).formatForTime([.day, .hour]))
//            Text("Total Earned")
//                .spacedOut(text: user.totalEarned().formattedForMoney())
//
//            Section {
//                NavigationLink("Saved Items") {
//                    SavedListView()
//                }
//            }
//
//            Section {
//                NavigationLink("Expenses") {
//                    ExpenseListView()
//                }
//            }
//        }
        .putInTemplate()
    }
    
    func expenseSection(expense: Expense) -> some View {
        newSection {
            HStack {
                Text("Current expense")
                    .font(.headline)
                Spacer()
                NavigationLink {
                    ExpenseListView()
                } label: {
                    Text("All")
                        .font(.subheadline)
                }
            }
            .padding(.trailing)
        } content: {
            NavigationLink {
                ExpenseDetailView(expense: expense)
            } label: {
                // Zstack with transparent top layer needed so you can press any part of button

                VStack(spacing: 15) {
                    HStack {
                        Text(expense.titleStr)
                            .font(.headline)
                            .pushLeft()

                        if expense.dueDate != nil {
                            Text("due in " + expense.timeRemaining.formatForTime([.year, .hour, .minute, .second]))
                                .font(.subheadline)
                            
                        }
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        ProgressBar(percentage: expense.percentPaidOff, color: settings.themeColor)
                        Text(expense.amountPaidOff.formattedForMoney())
                            .font(.subheadline)
                            .spacedOut {
                                Text(expense.amountRemainingToPayOff.formattedForMoney())
                                    .font(.subheadline)
                            }
                    }
                }
                .padding()
                .allPartsTappable()
            }
            .buttonStyle(.plain)
        }
    }

    func newSection<Content: View>(rectContainer: Bool = true,
                                   header: String,
                                   @ViewBuilder content: @escaping () -> Content)
        -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(header)
                .font(.headline)
            if rectContainer {
                content()
                    .centerInParentView()
                    .rectContainer(shadowRadius: 1, cornerRadius: 8)

            } else {
                content()
                    .centerInParentView()
            }
        }
    }

    func newSection<Nav: View, Content: View>(rectContainer: Bool = true,
                                              @ViewBuilder header: @escaping () -> Nav,
                                              @ViewBuilder content: @escaping () -> Content)
        -> some View {
        VStack(alignment: .leading, spacing: 7) {
            header()
            if rectContainer {
                content()
                    .centerInParentView()
                    .rectContainer(shadowRadius: 1, cornerRadius: 8)

            } else {
                content()
                    .centerInParentView()
            }
        }
    }

    func goalSection(goal: Goal) -> some View {
        newSection {
            HStack {
                Text("Current goal")
                    .font(.headline)
                Spacer()
                NavigationLink {
                    GoalListView()
                } label: {
                    Text("All")
                        .font(.subheadline)
                }
            }
            .padding(.trailing)

        } content: {
            NavigationLink {
                GoalDetailView(goal: goal)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(goal.titleStr)
                            .font(.headline)
                            .foregroundStyle(settings.getDefaultGradient())
                            .pushLeft()

                        HStack(alignment: .bottom, spacing: 5) {
                            Text(goal.amountMoneyStr)
                            Spacer()
                            Text("GOAL")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 4)

                        VStack {
                            VStack(spacing: 1) {
                                Text("Paid off")
                                    .font(.caption2)
                                    .spacedOut {
                                        Text(goal.amountPaidOff.formattedForMoney())
                                            .font(.caption2)
                                    }
                                ProgressBar(percentage: goal.percentPaidOff, color: settings.themeColor)
                            }

                            VStack(spacing: 1) {
                                Text("Remaining")
                                    .font(.caption2)
                                    .spacedOut {
                                        Text(goal.timeRemaining.formatForTime([.year, .day, .hour, .minute]))
                                            .font(.caption2)
                                    }
                            }
                        }
                        .padding(.top)
                        .pushTop(alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()

                    HStack {
                        VStack {
                            Image("disneyworld")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                //                            .clipShape(Circle())
                                //                            .height(90)
                                .frame(width: 150)
                                .cornerRadius(8)
                            
                            if let dueDate = goal.dueDate {
                                Text(dueDate.getFormattedDate(format: .abreviatedMonth))
                                    .font(.caption).foregroundColor(Color.hexStringToColor(hex: "8E8E93"))
                            }
                            
                        }
                        .padding()
                    }
                }
                .allPartsTappable()
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - HomeView_Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .putInNavView(.inline)
    }
}
