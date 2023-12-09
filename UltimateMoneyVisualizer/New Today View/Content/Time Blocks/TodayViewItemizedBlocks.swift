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
        VStack(spacing: 16) {
            header

            if !model.timeBlocksExpanded {
                compactView
            } else {
                if let shift = model.user.todayShift {
                    TodayViewTimeBlocksExpanded(shift: shift)
                }
            }

//            .frame(height: 115)
        }
    }

    @ViewBuilder var header: some View {
        HStack {
            Text("TIME BLOCKS")
            Spacer()
            Button {
                model.timeBlocksExpanded.toggle()
            } label: {
                Label("More", systemImage: model.timeBlocksHeaderButtonName)
                    .labelStyle(.iconOnly)
            }
        }
        .font(.callout)
        .fontWeight(.semibold)
        .foregroundStyle(Color(hex: "4E4E4E"))
    }

    @ViewBuilder var compactView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if let todayShift = model.user.todayShift {
                HStack {
                    ForEach(todayShift.getTimeBlocks()) { block in
                        TodayViewItemizedBlock(block: block)
                    }

                    if todayShift.getTimeBlocks().isEmpty {
                        TodayViewExampleItemizedBlock()
                    }

                    Button {
                        // TODO: Navigate to time block creation page

                        if let todayShift = model.user.todayShift {
                            navManager.appendCorrectPath(newValue: .createTimeBlockForToday(.init(start: nil, end: nil, todayShift: todayShift)))
                        }

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
                .padding(.bottom)
            }
        }
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
