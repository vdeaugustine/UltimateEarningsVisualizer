//
//  TodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import SwiftUI
import Vin

// MARK: - TodayView

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showHoursSheet = false
    @State private var showTimeOrMoney = "time"
    @State private var nowTime: Date = .now
    @State private var showBanner = false
    @State private var hasShownBanner = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State var todayShift: TodayShift? = nil
    var showingTime: Bool { showTimeOrMoney == "time" }

    @ObservedObject var user = User.main
    @ObservedObject var settings = User.main.getSettings()

    var body: some View {
        VStack {
            if let todayShift {
                ScrollView {
                    timeMoneyPicker
                        .padding(.vertical)
                    VStack {
                        startEndTotal(todayShift: todayShift)
                            .padding(.top)
                        progressSection(todayShift: todayShift)
                    }
                    .padding([.vertical, .top])
                    .background(Color.white)

                    payoffItemSection(todayShift: todayShift)

                    pieChartSection(todayShift: todayShift)
                }

            } else {
                Spacer()
                YouHaveNoShiftView(showHoursSheet: $showHoursSheet)
            }
        }

        .bottomBanner(isVisible: $showBanner, swipeToDismiss: false, buttonText: "Save")
        .background(Color.targetGray.frame(maxHeight: .infinity).ignoresSafeArea())
        .navigationTitle("Today Live")
        .sheet(isPresented: $showHoursSheet) {
            SelectHours(showHoursSheet: $showHoursSheet, todayShift: $todayShift)
        }
        .onReceive(timer) { _ in
            addSecond()
        }
    }

    private func addSecond() {
        nowTime = .now
        if let todayShift,
           let endTime = todayShift.endTime,
           !hasShownBanner {
            let shiftIsOver = nowTime >= endTime

            if shiftIsOver {
                showBanner = true
            }
        }
        processTemporaryAllocation()
    }

    private func processTemporaryAllocation() {
        if let currentGoal = user.getQueue().first as? Goal {
            
            
            
            
            do {
                var recentTempAlloc = currentGoal.getMostRecentTemporaryAllocation()
                if recentTempAlloc == nil {
                    print("No alloc exists, making new one")
                    recentTempAlloc = try TemporaryAllocation(initialAmount: 0,
                                                              expense: nil,
                                                              goal: currentGoal,
                                                              context: user.managedObjectContext ?? PersistenceController.context)
                }
                
                try recentTempAlloc?.add(amount: user.getWage().secondly, context: user.managedObjectContext ?? PersistenceController.context)
                

            } catch {
                print(error)
            }
        } else if let currentExpense = user.getQueue().first as? Expense {
            if let tempAlloc = currentExpense.temporaryAllocations?.allObjects as? [Expense] {
            }
        } else {
            print("no current item")
        }
    }
}

// MARK: - View functions and computed properties

extension TodayView {
    // MARK: - timeMoneyPicker

    var timeMoneyPicker: some View {
        Picker("Time/Money", selection: $showTimeOrMoney) {
            Text("Time")
                .tag("time")
            Text("Money")
                .tag("money")
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    // MARK: - Start End Total

    func startEndTotal(todayShift: TodayShift) -> some View {
        VStack {
            Text("Hours for \(Date.now.getFormattedDate(format: .abreviatedMonth))")
                .font(.headline)
                .spacedOut {
                    Button {
                        showHoursSheet.toggle()
                    } label: {
                        Text("Edit")
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)

            if let start = todayShift.startTime,
               let end = todayShift.endTime {
                HorizontalDataDisplay(
                    data: [.init(label: "Start",
                                 value: start.getFormattedDate(format: .minimalTime,
                                                               amPMCapitalized: false)),
                           .init(label: "End",
                                 value: end.getFormattedDate(format: .minimalTime,
                                                             amPMCapitalized: false)),

                           showingTime ? .init(label: "Total",
                                               value: todayShift.totalShiftDuration.formatForTime()) :
                               .init(label: "Will Earn",
                                     value: todayShift.totalWillEarn.formattedForMoney())]
                )
            }
        }
    }

    // MARK: - Individual Views

    func progressSection(todayShift: TodayShift) -> some View {
        VStack {
            HStack {
                Text(showingTime ? "Time" : "Money")
                Spacer()
                Text(showingTime ? todayShift.totalShiftDuration.formatForTime() : todayShift.totalWillEarn.formattedForMoney())
            }

            ProgressBar(percentage: todayShift.percentTimeCompleted(nowTime), color: settings.themeColor)

            HStack {
                Text(showingTime ? todayShift.elapsedTime(nowTime).formatForTime([.hour, .minute, .second]) : todayShift.totalEarnedSoFar(nowTime).formattedForMoney())
                Spacer()
                Text(showingTime ? todayShift.remainingTime(nowTime).formatForTime([.hour, .minute, .second]) : todayShift.remainingToEarn(nowTime).formattedForMoney())
            }
        }
        .font(.footnote)
        .padding()
        .padding(.top)
        .overlay {
            AnimatePlusAmount(str: "+" + (user.getWage().secondly * 2).formattedForMoneyExtended())
        }
    }

    // MARK: - Payoff Item Section

    func payoffItemSection(todayShift: TodayShift) -> AnyView {
        if let expense = user.getQueue().first as? Expense {
            return VStack {
                VStack {
                    HStack {
                        Text("Current Expense")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                    }

                    HStack {
                        ProgressCircle(percent: todayShift.percentTimeCompleted(nowTime),
                                       widthHeight: 100,
                                       lineWidth: 7) {
                            Text(User.main.getExpenses().first!.temporarilyPaidOff.formattedForMoney())
                                .font(.title)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .padding(5)
                        }

                        VStack(alignment: .leading) {
                            Text(expense.titleStr)
                                .font(.title2)
                            if let info = expense.info {
                                Text(info)
                                    .font(.subheadline)
                            }

                            Text(expense.amountMoneyStr)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(settings.getDefaultGradient())
                        }
                        .padding([.horizontal])
                        .pushLeft()
                    }
                }

                .padding()
            }
            .padding(.vertical)
            .anyView
        }
        else if let goal = user.getQueue().first as? Goal {
            return VStack {
                VStack {
                    HStack {
                        Text("Current Goal")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                    }

                    HStack {
                        ProgressCircle(percent: goal.percentTemporarilyPaidOff,
                                       widthHeight: 100,
                                       lineWidth: 7) {
                            Text(goal.temporarilyPaidOff.formattedForMoney())
                                .font(.title)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .padding(5)
                                .onChange(of: nowTime) { newValue in
                                    print(goal.titleStr, goal.temporarilyPaidOff.formattedForMoney())
                                }
                        }

                        VStack(alignment: .leading) {
                            Text(goal.titleStr)
                                .font(.title2)
                            if let info = goal.info {
                                Text(info)
                                    .font(.subheadline)
                            }
                            Text(goal.temporarilyPaidOff.formattedForMoney())

                            Text(goal.amountMoneyStr)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(settings.getDefaultGradient())
                        }
                        .padding([.horizontal])
                        .pushLeft()
                    }
                }

                .padding()
            }
            .padding(.vertical)
            .anyView
        } else {
            return AnyView(EmptyView())
        }
    }

    // MARK: - Pie Chart Section

    func pieChartSection(todayShift: TodayShift) -> some View {
        VStack {
            HStack {
                Text("Today's Spending Breakdown")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }

            HStack {
            }
        }

        .padding()
        .padding(.vertical)
        .background(Color.white)
    }
}

// MARK: - AnimatePlusAmount

struct AnimatePlusAmount: View {
    let str: String
    @State private var animate: Bool = true
    @ObservedObject private var settings = User.main.getSettings()
    var body: some View {
        VStack {
            Text(str)
                .font(.footnote)
                .foregroundColor(settings.themeColor)
                .offset(y: animate ? -15 : -5)
                .opacity(animate ? 1 : 0)
                .scaleEffect(animate ? 1.3 : 0.7)
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in

            if self.animate == true {
                self.animate = false
            } else {
                withAnimation(Animation.easeOut(duration: 1)) {
                    if self.animate == false {
                        self.animate = true
                    }
                }
            }
        }
    }
}

// MARK: - YouHaveNoShiftView

struct YouHaveNoShiftView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showHoursSheet: Bool
    @ObservedObject var settings = User.main.getSettings()

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "calendar.badge.clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 85)
                .foregroundColor(.gray)

            VStack(spacing: 14) {
                Text("Today's Shift")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text("You do not have a shift scheduled for today.")
                    .fontWeight(.medium)
            }

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, content: {
            Button {
                showHoursSheet = true
            } label: {
                ZStack {
                    Capsule()
                        .fill(settings.getDefaultGradient())
                    Text("Add Shift")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .frame(width: 135, height: 50)
            }

        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

// MARK: - SelectHours

struct SelectHours: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var start: Date = .nineAM
    @State private var end: Date = .fivePM
    @Binding var showHoursSheet: Bool
    @Binding var todayShift: TodayShift?

    @ObservedObject var settings = User.main.getSettings()
    @ObservedObject var user = User.main

    var body: some View {
        Form {
            DatePicker("Start Time", selection: $start, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $end, displayedComponents: .hourAndMinute)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                do {
                    let ts = try TodayShift(startTime: start, endTime: end, user: user, context: viewContext)
                    print(user.getTodayShift() ?? "NO TODAY SHIFT")

                    todayShift = ts

                    showHoursSheet = false

                } catch {
                    print(error)
                }

            } label: {
                ZStack {
                    Capsule()
                        .fill(settings.getDefaultGradient())
                    Text("Save")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .frame(width: 135, height: 50)
            }
        }
        .navigationTitle("Set hours")
        .background(Color.clear)
        .putInTemplate()
        .putInNavView(.inline)
        .presentationDetents([.medium, .fraction(0.9_999_999_999_999_999)])
        .presentationDragIndicator(.visible)
        .tint(.white)
        .accentColor(.white)
    }
}

// MARK: - TodayView_Previews

struct TodayView_Previews: PreviewProvider {
    static let ts: TodayShift = {
        let ts = TodayShift(context: PersistenceController.context)
        ts.startTime = Date.now.addMinutes(-20)
        ts.endTime = Date.now.addMinutes(4)
        ts.user = User.main
        ts.expiration = Date.endOfDay()
        ts.dateCreated = .now
        return ts
    }()

    static var previews: some View {
        TodayView(todayShift: ts)
            .putInTemplate()
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
