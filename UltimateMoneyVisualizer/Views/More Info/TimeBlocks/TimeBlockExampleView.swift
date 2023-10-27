//
//  TimeBlockExampleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/26/23.
//

import SwiftUI
import Vin

struct TimeBlockExampleView: View {
    @State private var timesToShow: [Date] = []

    struct PseudoBlock {
        let title: String
        let start: String
        let end: String
        let color: Color
        let earned: String
    }

    struct StartAndEnd: Hashable {
        let start: Date
        let end: Date
    }

    func plusNavigation() -> some View {
        Image(systemName: "plus.circle")
//            .padding(.top, -12)
            .foregroundStyle(.tint)
    }

    func money(forTime minutes: Double) -> String {
        let perMinute: Double = 20 / 60
        return (perMinute * minutes).money()
    }

    var body: some View {
        // ScrollView {
        VStack {
            Group {
                divider(time: "9:00 AM")

                row(
                    .init(title: "Morning routine",
                          start: "9:00 AM",
                          end: "10:00 AM",
                          color: .yellow,
                          earned: money(forTime: 60))
                )

                divider(time: "10:00 AM")

                row(
                    .init(title: "Checked email",
                          start: "10:00 AM",
                          end: "11:30 AM",
                          color: Color(uiColor: .magenta),
                          earned: money(forTime: 90))
                )

                divider(time: "11:30 AM")

                row(
                    .init(title: "Focused work session",
                          start: "11:30 AM",
                          end: "12:07 PM",
                          color: .green,
                          earned: money(forTime: 37))
                )

                divider(time: "12:07 PM")

                plusNavigation()

                divider(time: "12:30 PM")

                row(
                    .init(title: "Lunch",
                          start: "12:30 PM",
                          end: "1:30 PM",
                          color: .indigo,
                          earned: money(forTime: 60))
                )
                
                divider(time: "1:30 PM")
            }
            
            row(
                .init(title: "Meetings",
                      start: "1:30 PM",
                      end: "2:50 PM",
                      color: .indigo,
                      earned: money(forTime: 30 + 50))
            )
            
            divider(time: "2:50")
            
            plusNavigation()
            

//            if let first = shift.getTimeBlocks().first,
//               let startOfFirst = first.startTime,
//               let shiftStart = shift.startDate,
//               startOfFirst > shiftStart {
//                plusNavigation(start: shiftStart, end: startOfFirst)
//                    .offset(y: 4)
//            }

//            ForEach(shift.getTimeBlocks()) { timeBlock in
//                timeBlockSection(timeBlock: timeBlock)
//                    .onTapGesture {
//                        navManager.appendCorrectPath(newValue: .timeBlockDetail(timeBlock))
//                    }
//            }

//            if let last = shift.getTimeBlocks().last,
//               let endOfLast = last.endTime,
//               let shiftEnd = shift.endDate,
//               endOfLast < shiftEnd {
//                plusNavigation(start: endOfLast, end: shiftEnd)
//                    .offset(y: 4)
//            }

//            if shift.getTimeBlocks().isEmpty {
//                plusNavigation(start: shift.start, end: shift.end)
//                    .offset(y: 4)
//            }

            divider(time: "5:00 PM")
        }
    }

    func timeBlockSection(timeBlock: PseudoBlock, topDiv: Bool = true, bottomDiv: Bool = true) -> some View {
        VStack(spacing: 15) {
            if topDiv {
                divider(time: timeBlock.start)
            }
            row(timeBlock)

            if bottomDiv {
                divider(time: timeBlock.end)
            }
        }
    }

    func timeBlockPill(timeBlock: TimeBlock) -> some View {
        HStack {
            if let title = timeBlock.title {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)

                Spacer()

                Text(timeBlock.amountEarned().money())
                    .font(.caption)
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

    @ViewBuilder
    func row(_ block: PseudoBlock) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(block.color)
                .frame(width: 3)
                .padding(.vertical, 1)

            VStack(alignment: .leading) {
                Text(block.title)
                    .format(size: 14, weight: .bold)
                    .lineLimit(1)

                Text("\(block.start) - \(block.end)")
                    .font(.caption)
                    .lineLimit(1)
            }
            .lineLimit(1)
            Spacer()

            Text(block.earned)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background {
            Color(.secondarySystemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }

        .frame(height: 50)
    }

    func divider(time: String) -> some View {
        HStack(spacing: 9) {
            Text(time)
                .font(.footnote)
            VStack { Divider() }
        }
    }
}

#Preview {
    TimeBlockExampleView()
}
