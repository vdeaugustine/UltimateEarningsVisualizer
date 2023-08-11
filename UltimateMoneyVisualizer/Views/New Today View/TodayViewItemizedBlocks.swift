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
            HStack {
                Text("TIME BLOCKS")

                Spacer()

            }
            .font(.lato(16))
            .fontWeight(.semibold)
            .tracking(1)
            .foregroundStyle(Color(hex: "4E4E4E"))

            ScrollView(.horizontal, showsIndicators: false) {
                if let todayShift = model.user.todayShift {
                    HStack {
                        ForEach(todayShift.getTimeBlocks()) { block in
                            TodayViewItemizedBlock(block: block)
//                                .padding(.vertical)
                        }

                        if todayShift.getTimeBlocks().isEmpty {
                            TodayViewExampleItemizedBlock()
//                                .padding(.vertical)
                        }

                        Button {
                            // TODO: Navigate to time block creation page

                            if let todayShift = model.user.todayShift {
                                navManager.todayViewNavPath.appendTodayView(.newTimeBlock(todayShift))
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
//            .frame(height: 115)
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


