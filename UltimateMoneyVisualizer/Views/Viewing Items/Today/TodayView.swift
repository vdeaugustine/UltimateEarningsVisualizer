//
//  TodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import SwiftUI
import Vin

// MARK: - TodayViewViewModel

class TodayViewViewModel: ObservableObject {
    
    static let shared = TodayViewViewModel()
    
    @Published var showHoursSheet = false
    @Published var selectedSegment: SelectedSegment = .money
    @Published var nowTime: Date = .now
    @Published var showBanner = false
    @Published var hasShownBanner = false
    @Published var showDeleteWarning = false

    enum SelectedSegment: String, Identifiable, Hashable {
        var id: SelectedSegment { self }
        case money, time
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State var todayShift: TodayShift? = User.main.todayShift

    @ObservedObject var user = User.main
    @ObservedObject var settings = User.main.getSettings()

    var isCurrentlyMidShift: Bool {
        guard let todayShift,
              let start = todayShift.startTime,
              let end = todayShift.endTime,
              nowTime >= start,
              nowTime <= end
        else {
            return false
        }
        return true
    }

    // MARK: - Today's Spending Section

    func todaysSpending(todayShift: TodayShift) -> some View {
        VStack {
            HStack {
                Text("Today's Spending")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()

                NavigationLink("Edit Queue") {
                    PayoffQueueView()
                }
            }

            TodayPayoffGrid(shiftDuration: todayShift.totalShiftDuration,
                            haveEarned: todayShift.totalEarnedSoFar(nowTime))
        }

        .padding()
        .padding(.vertical)
        .background(Color.white)
    }

    func addSecond() {
        nowTime = .now
        if let todayShift,
           let endTime = todayShift.endTime,
           !hasShownBanner {
            if isCurrentlyMidShift == false {
                showBanner = true
            }
        }
    }
}

// MARK: - TodayView

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject private var vm = TodayViewViewModel.shared

    var body: some View {
        VStack {
            if let todayShift = vm.todayShift {
                ScrollView {
                    TimeMoneyPicker(showTimeOrMoney: $vm.selectedSegment)
                        .padding(.vertical)
                    VStack {
                        StartEndTotalView(vm: vm,
                                          showHoursSheet: $vm.showHoursSheet,
                                          showingTime: vm.selectedSegment == .time)

                            .padding(.top)
                        ProgressSectionView(showingTime: vm.selectedSegment == .time,
                                            todayShift: todayShift,
                                            nowTime: vm.nowTime,
                                            settings: vm.settings,
                                            isCurrentlyMidShift: vm.isCurrentlyMidShift,
                                            user: vm.user)
                    }
                    .padding([.vertical, .top])
                    .background(Color.white)

                    vm.todaysSpending(todayShift: todayShift)
                }

            } else {
                Spacer()
                YouHaveNoShiftView(showHoursSheet: $vm.showHoursSheet)
            }
        }
        .onAppear(perform: vm.user.updateTempQueue)
        .putInTemplate()
        .bottomBanner(isVisible: $vm.showBanner, swipeToDismiss: false, buttonText: "Save") {
            do {
                try vm.todayShift?.finalizeAndSave(user: vm.user, context: viewContext)
            } catch {
                print("Error saving")
            }
        }
        .background(Color.targetGray.frame(maxHeight: .infinity).ignoresSafeArea())
        .navigationTitle("Today Live")
        .sheet(isPresented: $vm.showHoursSheet) {
            SelectHours(showHoursSheet: $vm.showHoursSheet, todayShift: $vm.todayShift)
        }
        .onReceive(vm.timer) { _ in
            guard vm.isCurrentlyMidShift else { return }

            vm.addSecond()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete") {
                    vm.showDeleteWarning.toggle()
                }
            }
        }
        .confirmationDialog("Delete Today Shift", isPresented: $vm.showDeleteWarning, titleVisibility: .visible) {
            Button("Confirm", role: .destructive) {
                vm.todayShift = nil
                if let userShift = vm.user.todayShift {
                    viewContext.delete(userShift)
                }
                vm.user.todayShift = nil
            }
        }
    }
}

// MARK: - View functions and computed properties

extension TodayView {
    // MARK: - timeMoneyPicker

    struct TimeMoneyPicker: View {
        @Binding var showTimeOrMoney: TodayViewViewModel.SelectedSegment

        var body: some View {
            Picker("Time/Money", selection: $showTimeOrMoney) {
                Text("Money")
                    .tag(TodayViewViewModel.SelectedSegment.money)
                Text("Time")
                    .tag(TodayViewViewModel.SelectedSegment.time)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
        }
    }

    // MARK: - Start End Total

    struct StartEndTotalView: View {
        @ObservedObject var vm: TodayViewViewModel
        @Binding var showHoursSheet: Bool
        let showingTime: Bool
        typealias dataItems = [HorizontalDataDisplay.DataItem]
        let horizontalData: dataItems = [.init(label: "Start",
                                               value: vm.todayShift!.start.getFormattedDate(format: .minimalTime,
                                                                                amPMCapitalized: false),
                                               view: nil),
                                         .init(label: "End",
                                               value: vm.end.getFormattedDate(format: .minimalTime,
                                                                              amPMCapitalized: false),
                                               view: nil),
                                         showingTime ?
                                             .init(label: "Total",
                                                   value: vm.todayShift.totalShiftDuration.formatForTime(),
                                                   view: nil) :
                                             .init(label: "Will Earn",
                                                   value: vm.todayShift.totalWillEarn.formattedForMoney(),
                                                   view: nil)]

        var body: some View {
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
                    HorizontalDataDisplay(data: horizontalData)
                }
            }
        }
    }

    // MARK: - Individual Views

    struct ProgressSectionView: View {
        let showingTime: Bool
        let nowTime: Date
        let settings: Settings // Assuming you have a `Settings` model

        var isCurrentlyMidShift: Bool

        var user: User

        var body: some View {
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
                if isCurrentlyMidShift {
                    AnimatePlusAmount(str: "+" + (user.getWage().secondly * 2).formattedForMoneyExtended())
                }
            }
        }
    }

    // MARK: - Payoff Item Section
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

                    todayShift = ts

                    user.todayShift = ts
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
        ts.startTime = .nineAM
        ts.endTime = .now.addHours(5)
        ts.user = User.main
        ts.expiration = Date.endOfDay()
        ts.dateCreated = .now
        return ts
    }()

    static var previews: some View {
        TodayView()
            .putInTemplate()
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
