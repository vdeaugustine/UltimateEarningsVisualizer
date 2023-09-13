//
//  TodayViewItemizedPart.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/21/23.
//

import SwiftUI

// MARK: - TodayViewItemizedPart

struct TodayViewItemizedPart: View {
    @EnvironmentObject private var navManager: NavManager

    @EnvironmentObject private var viewModel: TodayViewModel

    @State private var timesToShow: [Date] = []

    

    func plusNavigation(start: Date, end: Date) -> some View {
        Image(systemName: "plus.circle")
            .padding(.top, -12)
            .foregroundStyle(viewModel.settings.getDefaultGradient())
            .onTapGesture {
                // TODO: Figure this out
                navManager.homeNavPath.append(TodayViewModel.StartAndEnd(start: start, end: end))
            }
    }

    var body: some View {
        // ScrollView {
        VStack {
            if let shift = viewModel.user.todayShift {
                divider(time: shift.startTime ?? viewModel.start)

                if let first = shift.getTimeBlocks().first,
                   let startOfFirst = first.startTime,
                   let shiftStart = shift.startTime,
                   startOfFirst > shiftStart {
                    plusNavigation(start: shiftStart, end: startOfFirst)
                }

                ForEach(shift.getTimeBlocks()) { timeBlock in
                    timeBlockSection(timeBlock: timeBlock)
                        .onTapGesture {
                            navManager.appendCorrectPath(newValue: .timeBlockDetail(timeBlock))
                        }
                }

                if let last = shift.getTimeBlocks().last,
                   let endOfLast = last.endTime,
                   let shiftEnd = shift.endTime,
                   endOfLast < shiftEnd {
                    plusNavigation(start: endOfLast, end: shiftEnd)
                }

                if shift.getTimeBlocks().isEmpty {
                    if let start = shift.startTime,
                       let end = shift.endTime {
                        plusNavigation(start: start, end: end)
                    }
                }

                if let end = shift.endTime {
                    divider(time: end)
                }
            }
        }
//        .navigationDestination(for: StartAndEnd.self) { newVal in
//            CreateNewTimeBlockView(shift: shift, start: newVal.start, end: newVal.end)
//        }
        .navigationDestination(for: TimeBlock.self) { block in
            TimeBlockDetailView(block: block)
        }
        // }
    }

    func timeBlockSection(timeBlock: TimeBlock) -> some View {
        VStack(spacing: 15) {
            if viewModel.startMatchesAnotherBlocksEnd(timeBlock) == false,
               let startTime = timeBlock.startTime {
                divider(time: startTime)
            }
            timeBlockPill(timeBlock: timeBlock)

            if let endTime = timeBlock.endTime {
                divider(time: endTime)

                if viewModel.gaps.contains(endTime) {
                    plusNavigation(start: endTime,
                                   end: viewModel.getBlockAfter(this: timeBlock)?.startTime ?? endTime)
                }
            }
        }
    }

    func timeBlockPill(timeBlock: TimeBlock) -> some View {
        HStack {
            if let title = timeBlock.title {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.white)

                Spacer()

                Text(timeBlock.amountEarned().money())
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(timeBlock.getColor())
        }
    }

    func divider(time: Date) -> some View {
        HStack(spacing: 9) {
            Text(time.getFormattedDate(format: .minimalTime))
                .font(.system(size: 13))
            Rectangle()
                .frame(height: 1.5)
                .foregroundColor(Color.black)
                .cornerRadius(2)
        }
    }
}

extension ItemizedPartOfShiftView {}

// MARK: - TodayViewItemizedPart_Previews

struct TodayViewItemizedPart_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TodayViewItemizedPart()
                .environmentObject(TodayViewModel.main)
        }
    }
}
