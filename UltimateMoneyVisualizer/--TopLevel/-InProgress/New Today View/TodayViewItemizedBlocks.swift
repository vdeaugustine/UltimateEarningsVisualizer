//
//  TodayViewItemizedBlocks.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/21/23.
//

import SwiftUI

// MARK: - TodayViewItemizedBlocks

struct TodayViewItemizedBlocks: View {
    @EnvironmentObject private var model: TodayViewModel
    @EnvironmentObject private var navManager: NavManager

    var testBlocks: [TimeBlock] {
        User.main.getShifts().sorted(by: { $0.getTimeBlocks().count > $1.getTimeBlocks().count }).first!.getTimeBlocks()
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if let todayShift = model.user.todayShift {
                HStack {
                    ForEach(todayShift.getTimeBlocks()) { block in
                        TodayViewItemizedBlock(block: block)
                            .padding(.vertical)
                    }

                    if todayShift.getTimeBlocks().isEmpty {
                        TodayViewExampleItemizedBlock()
                        .padding(.vertical)
                    }

                    Button {
                        //TODO: Navigate to time block creation page
                        navManager.todayViewNavPath.append(TodayViewModel.StartAndEnd(start: .now, end: .now.addMinutes(15)))
                    } label: {
                        Label("Add Block", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .padding()
                            .background {
                                Color.white
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 1, y: 3)
                            }
                    }
                    .padding(.leading)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .frame(height: 115)
    }
}

// MARK: - TodayViewItemizedBlocks_Previews

struct TodayViewItemizedBlocks_Previews: PreviewProvider {
    static let block: TimeBlock = {
        User.main.getShifts().sorted(by: { $0.getTimeBlocks().count > $1.getTimeBlocks().count }).first!.getTimeBlocks().randomElement()!
    }()

    static var previews: some View {
        ZStack {
            Color.targetGray
            TodayViewItemizedBlocks()
                .environmentObject(TodayViewModel.main)
                .environmentObject(NavManager.shared)
        }
    }
}

// MARK: - TodayViewItemizedBlock

struct TodayViewItemizedBlock: View {
    let block: TimeBlock
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(block.getColor())
                .frame(width: 3)
                .padding(.vertical, 5)

            VStack(alignment: .leading) {
                Text(block.getTitle())
                    .font(.lato(16))
                    .fontWeight(.heavy)

                Text(block.timeRangeString())
                    .font(.lato(14))
                Text(block.duration.breakDownTime())
                    .font(.lato(14))
            }
            .lineLimit(1)
        }
        .padding()
        .background {
            Color(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.25), radius: 2, x: 1, y: 3)
        }
        .frame(height: 100)
    }
}

struct TodayViewExampleItemizedBlock: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.defaultColorOptions.first!)
                .frame(width: 3)
                .padding(.vertical, 5)

            VStack(alignment: .leading) {
                Text("Example time block")
                    .font(.lato(16))
                    .fontWeight(.heavy)

                Text("10:00 - 11:30 AM")
                    .font(.lato(14))
                Text("1h 30m")
                    .font(.lato(14))
            }
            .lineLimit(1)
        }
        .padding()
        .background {
            Color(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.25), radius: 2, x: 1, y: 3)
        }
        .frame(height: 100)
    }
}
