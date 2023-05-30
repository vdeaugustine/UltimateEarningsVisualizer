//
//  StatsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/4/23.
//

import Charts
import SwiftUI
import Vin

// MARK: - StatsView

struct StatsView: View {
    enum MoneySection: String, CaseIterable, Identifiable {
        case earned, spent, saved, goals
//        case all
        var id: MoneySection { self }
    }

    @State private var selectedSection: MoneySection = .earned
    @State private var firstDate: Date = .now.addDays(-5)
    @State private var secondDate: Date = .endOfDay()

    @ObservedObject private var user: User = User.main

    private var dataItems: [HorizontalDataDisplay.DataItem] {
        var retArr = [HorizontalDataDisplay.DataItem]()

        switch selectedSection {
            // TODO: Figure out if you want to have an ALL section
//            case .all:
//                retArr = [.init(label: "Items", value: user.getShiftsBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
//                          .init(label: "Amount", value: user.totalNetMoneyBetween(firstDate, secondDate).formattedForMoney(), view: nil),
//                          .init(label: "Time", value: user.convertMoneyToTime(money: user.totalNetMoneyBetween(firstDate, secondDate)).formatForTime(), view: nil)]
            case .earned:
                retArr = [.init(label: "Shifts", value: user.getShiftsBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                          .init(label: "Amount", value: user.getTotalEarnedBetween(startDate: firstDate, endDate: secondDate).formattedForMoney(), view: nil),
                          .init(label: "Time", value: user.getTimeWorkedBetween(startDate: firstDate, endDate: secondDate).formatForTime(), view: nil)]
            case .spent:
                retArr = [.init(label: "Expenses", value: user.getExpensesBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                          .init(label: "Amount", value: user.getExpensesSpentBetween(startDate: firstDate, endDate: secondDate).formattedForMoney(), view: nil),
                          .init(label: "Time", value: user.convertMoneyToTime(money: user.getExpensesSpentBetween(startDate: firstDate, endDate: secondDate)).formatForTime(), view: nil)]
            case .saved:
                retArr = [.init(label: "Saved", value: user.getSavedBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                          .init(label: "Amount", value: user.getAmountSavedBetween(startDate: firstDate, endDate: secondDate).formattedForMoney(), view: nil),
                          .init(label: "Time", value: user.convertMoneyToTime(money: user.getAmountSavedBetween(startDate: firstDate, endDate: secondDate)).formatForTime(), view: nil)]
            case .goals:
                retArr = [.init(label: "Goals", value: user.getGoalsBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                          .init(label: "Amount", value: user.getGoalsSpentBetween(startDate: firstDate, endDate: secondDate).formattedForMoney(), view: nil),
                          .init(label: "Time", value: user.convertMoneyToTime(money: user.getGoalsSpentBetween(startDate: firstDate, endDate: secondDate)).formatForTime(), view: nil)]
        }

        return retArr
    }

    var body: some View {
        ScrollView {
            Picker("Section", selection: $selectedSection) {
                ForEach(MoneySection.allCases) { section in
                    Text(section.rawValue.capitalized).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            HorizontalDataDisplay(data: dataItems)

            HStack {
                DatePicker("", selection: $firstDate, in: .init(uncheckedBounds: (lower: Date.distantPast, upper: secondDate)), displayedComponents: .date).labelsHidden()
                Text("-")
                DatePicker("", selection: $secondDate, in: .init(uncheckedBounds: (lower: firstDate, upper: .distantFuture)), displayedComponents: .date).labelsHidden()
            }
            .padding(.vertical, 10)

            // MARK: - Selected Section

            switch selectedSection {
//                case .all:
//                    Text("All")
                case .earned:
                    earnedSection
                case .spent:
                    spentSection
                case .saved:
                    savedSection
                case .goals:
                    goalsSection
            }
        }
        .background(Color.targetGray)
        .putInTemplate()
        .navigationTitle("My Stats")
    }

    // MARK: - Earned Section

    var earnedSection: some View {
        VStack {
            VStack(spacing: 0) {
                LineChart()
                    .frame(height: 300)

                Text("Shows the total amount of money you had earned up to each day, including all previous days not shown")
                    .font(.footnote)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
            }
            .padding([.horizontal, .bottom])

            homeSection(rectContainer: false, header: "Shifts") {
                LazyVStack {
                    ForEach(user.getShiftsBetween(startDate: firstDate, endDate: secondDate)) { shift in

                        NavigationLink(destination: ShiftDetailView(shift: shift)) {
                            HStack {
                                HStack(spacing: 15) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(.green)
                                    Text(shift.start.getFormattedDate(format: .abreviatedMonth))
                                }
                                Spacer()
                                Text(shift.totalEarned.formattedForMoney())
                            }
                            .padding([.horizontal])
                            .padding(.top, 2)
                            .allPartsTappable()
                        }
                        Divider()
                    }
                }
                .padding(.top, 10)
                .rectContainer(shadowRadius: 0)
            }
            .padding()
            .padding(.horizontal, 5)
        }
    }

    // MARK: - Saved Section

    var savedSection: some View {
        VStack {
            VStack(spacing: 0) {
                LineChart()
                    .frame(height: 300)

                Text("Shows the total amount of money you had saved up to each day, including all previous days not shown")
                    .font(.footnote)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
            }
            .padding([.horizontal, .bottom])

            homeSection(rectContainer: false, header: "Saved") {
                LazyVStack {
                    ForEach(user.getSavedBetween(startDate: firstDate, endDate: secondDate)) { saved in

                        VStack {
                            NavigationLink {
                                SavedDetailView(saved: saved)
                            } label: {
                                HStack {
                                    HStack(spacing: 15) {
                                        Image(systemName: "chart.line.downtrend.xyaxis")
                                            .foregroundColor(.red)
                                        Text(saved.getTitle())
                                    }
                                    Spacer()
                                    Text(saved.getAmount().formattedForMoney())
                                }
                            }
                            .padding([.top, .horizontal])
                            Divider()
                        }
                    }
                }
                .padding(.top, 10)
                .rectContainer(shadowRadius: 0)
            }
            .padding()
            .padding(.horizontal, 5)
        }
    }

    // MARK: - Spent Section

    var spentSection: some View {
        VStack {
            VStack(spacing: 0) {
                LineChart()
                    .frame(height: 300)

                Text("Shows the total amount of money you had spent up to each day, including all previous days not shown")
                    .font(.footnote)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
            }
            .padding([.horizontal, .bottom])

            homeSection(rectContainer: false, header: "Expenses") {
                LazyVStack {
                    ForEach(user.getExpensesBetween(startDate: firstDate, endDate: secondDate)) { expense in

                        VStack {
                            NavigationLink {
                                ExpenseDetailView(expense: expense)
                            } label: {
                                HStack {
                                    HStack(spacing: 15) {
                                        Image(systemName: "chart.line.downtrend.xyaxis")
                                            .foregroundColor(.red)
                                        Text(expense.titleStr)
                                    }
                                    Spacer()
                                    Text(expense.amountMoneyStr)
                                }
                            }
                            .padding([.top, .horizontal])
                            Divider()
                        }
                    }
                }
                .rectContainer(shadowRadius: 0)
            }
            .padding()
            .padding(.horizontal, 5)
        }
    }

    // MARK: - Goals Section

    var goalsSection: some View {
        VStack {
            VStack(spacing: 0) {
                LineChart()
                    .frame(height: 300)

                Text("Shows the total amount of money you had spent up to each day, including all previous days not shown")
                    .font(.footnote)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
            }
            .padding([.horizontal, .bottom])

            homeSection(rectContainer: false, header: "Goals") {
                    List {
                        ForEach(user.getGoalsBetween(startDate: firstDate, endDate: secondDate)) { goal in

                            VStack {
                                NavigationLink {
                                    GoalDetailView(goal: goal)
                                } label: {
                                    HStack {
                                        HStack(spacing: 15) {
                                            Image(systemName: "chart.line.downtrend.xyaxis")
                                                .foregroundColor(.red)
                                            Text(goal.titleStr)
                                                .foregroundStyle(user.getSettings().getDefaultGradient())
                                        }
                                        Spacer()
                                        Text(goal.amountMoneyStr)
                                            .foregroundStyle(user.getSettings().getDefaultGradient())
                                    }
                                }
                            }
                        }
                    }
                    .cornerRadius(10)
                    .frame(height: 300)
                    .listStyle(.plain)
            }
            .padding()
        }
    }

    struct LineChart: View {
        @ObservedObject private var user = User.main
        var title: String? = nil
        var backgroundColor: Color? = nil

        var body: some View {
            ZStack {
                if let backgroundColor = backgroundColor {
                    backgroundColor
                }
                VStack {
                    if let title = title {
                        Text(title.uppercased())
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
//                    Chart {
//                        ForEach((-5 ... 0), id: \.self) { ind in
//                            LineMark(x: .value("Day", Date.getDayOfWeek(daysBack: ind)),
//                                     y: .value("Value", user.getTotalEarnedBetween(endDate: .now.addDays(Double(ind)))))
//                            PointMark(x: .value("Day", Date.getDayOfWeek(daysBack: ind)),
//                                      y: .value("Value", user.getTotalEarnedBetween(ind)))
//                        }
//                    }

                    VStack {
                        StatsViewChart()
                    }
                    .rectContainer(shadowRadius: 0.02)

                    .padding(.horizontal, 5)
                }
                .padding(.vertical)
            }
        }
    }
}

// MARK: - StatsView_Previews

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .putInNavView(.inline)
    }
}
