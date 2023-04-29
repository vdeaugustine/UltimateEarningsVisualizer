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
    @State private var showHoursSheet = false
    @State private var showTimeOrMoney = "time"
    @State private var nowTime: Date = .now

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var todayShift: TodayShift?
    var showingTime: Bool { showTimeOrMoney == "time" }

    var body: some View {
        VStack {
            if let todayShift {
                Text("Start \(todayShift.startTime!.getFormattedDate(format: .minimalTime))")
                Text("End \(todayShift.endTime!.getFormattedDate(format: .minimalTime))")
                
                timeMoneyPicker
                progressSection(todayShift: todayShift)
            } else {
                YouHaveNoShiftView(showHoursSheet: $showHoursSheet)
            }
        }
        .navigationTitle("Today Live")
        .sheet(isPresented: $showHoursSheet) {
            SelectHours(showHoursSheet: $showHoursSheet)
        }
        .onReceive(timer) { _ in
            nowTime = .now
        }
    }
}

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

    // MARK: - Individual Views

    func progressSection(todayShift: TodayShift) -> some View {
        VStack {
            HStack {
                Text(showingTime ? "Time" : "Money")
                Spacer()
                Text(showingTime ? todayShift.totalShiftDuration.formatForTime() : todayShift.totalWillEarn.formattedForMoney())
            }

            ProgressBar(percentage: todayShift.percentTimeCompleted(nowTime), color: UserDefaults.themeColor)

            HStack {
                Text(showingTime ?  todayShift.elapsedTime(nowTime).formatForTime([.hour, .minute, .second]) : todayShift.totalEarnedSoFar(nowTime).formattedForMoney())
                Spacer()
                Text((showingTime ? todayShift.remainingTime(nowTime).formatForTime([.hour, .minute, .second]) : todayShift.remainingToEarn(nowTime).formattedForMoney()))
            }
        }
        .font(.footnote)
        .padding()
        .padding(.top)

//        .if(nowTimeInShiftTime) { selfView in
//            selfView
//                .overlay {
//                    AnimatePlusAmount(str: "+" + (model.wage.amountPerSecond() * 2).formattedForMoneyExtended())
//                }
//        }
    }
}

struct ProgressBar: View {
    let percentage: Double
    let cornerRadius: CGFloat = 25
    let height: CGFloat = 8
    var color: Color = .accentColor
    
    private var isComplete: Bool {
        percentage >= 1
    }
    
    private var percentageToUse: Double {
        if percentage < 0 { return 0 }
        if percentage > 1 { return 1 }
        if percentage == 0 { return 0.01 }
        return percentage
    }
    
    private func barPart(width: CGFloat) -> some View {
        let entireBarWidth = width
        return ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.gray)
                .frame(width: entireBarWidth)
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(isComplete ? .green : color)
                .frame(width: percentageToUse * entireBarWidth)
        }
        .frame(height: height)
    }
    
    var body: some View {
        GeometryReader { geo in
            barPart(width: geo.size.width)
        }
        .frame(height: height)
    }
}


// MARK: - YouHaveNoShiftView

struct YouHaveNoShiftView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showHoursSheet: Bool

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
        .safeAreaInset(edge: .bottom, content: {
            Button {
                showHoursSheet = true

            } label: {
                ZStack {
                    Capsule()
                        .fill(UserDefaults.getDefaultGradient())
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

    var body: some View {
        Form {
            DatePicker("Start Time", selection: $start, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $end, displayedComponents: .hourAndMinute)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                let todayShift = TodayShift(context: viewContext)
                todayShift.startTime = start
                todayShift.endTime = end

                todayShift.expiration = Date.endOfDay(start)
                todayShift.dateCreated = .now

                todayShift.user = User.main

                do {
                    try viewContext.save()
                    showHoursSheet = false
                } catch {
                    print(error)
                }

            } label: {
                ZStack {
                    Capsule()
                        .fill(UserDefaults.getDefaultGradient())
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
        ts.startTime = Date.now.addMinutes(-1)
        ts.endTime = Date.now.addMinutes(1)
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
