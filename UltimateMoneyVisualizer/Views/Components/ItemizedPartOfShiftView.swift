//
//  ItemizedPartOfShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import SwiftUI

extension Color {
    func addWhiteness(_ num: CGFloat) -> Color {
        Color(red: components.red + (num / 255),
              green: components.green + (num / 255),
              blue: components.blue + (num / 255),
              opacity: components.opacity)
    }
}

// MARK: - ItemizedPartOfShiftView

struct ItemizedPartOfShiftView: View {
    @EnvironmentObject private var navManager: NavManager
    @ObservedObject private var settings = User.main.getSettings()
    @Environment(\.colorScheme) var colorScheme
    let shift: Shift

    @State private var timesToShow: [Date] = []

    var gaps: [Date] {
        var retArr: [Date] = []
        let shiftsBlocks = shift.getTimeBlocks()
        for blockIndex in shiftsBlocks.indices {
            guard let thisBlock = shiftsBlocks.safeGet(at: blockIndex),
                  let nextBlock = shiftsBlocks.safeGet(at: blockIndex + 1),
                  let thisBlockEnd = thisBlock.endTime,
                  let nextBlockStart = nextBlock.startTime
            else { continue }

            if !compareDates(thisBlockEnd, nextBlockStart, accuracy: .minute) {
                retArr.append(thisBlockEnd)
            }
        }

        return retArr
    }

    struct StartAndEnd: Hashable {
        let start: Date
        let end: Date
    }

    func plusNavigation(start: Date, end: Date) -> some View {
        Image(systemName: "plus.circle")
            .padding(.top, -12)
            .foregroundStyle(settings.themeColor.addWhiteness(30 * (colorScheme == .dark ? 1 : 0)))
            .onTapGesture {
                // TODO: Figure this out
                navManager.appendCorrectPath(
                    newValue: .createTimeBlockForShift(.init(start: start,
                                                             end: end,
                                                             shift: shift))
                )
            }
    }

    var body: some View {
        // ScrollView {
        VStack {
            divider(time: shift.start)

            if let first = shift.getTimeBlocks().first,
               let startOfFirst = first.startTime,
               let shiftStart = shift.startDate,
               startOfFirst > shiftStart {
                plusNavigation(start: shiftStart, end: startOfFirst)
                    .offset(y: 4)
            }

            ForEach(shift.getTimeBlocks()) { timeBlock in
                timeBlockSection(timeBlock: timeBlock)
                    .onTapGesture {
                        navManager.appendCorrectPath(newValue: .timeBlockDetail(timeBlock))
                    }
            }

            if let last = shift.getTimeBlocks().last,
               let endOfLast = last.endTime,
               let shiftEnd = shift.endDate,
               endOfLast < shiftEnd {
                plusNavigation(start: endOfLast, end: shiftEnd)
                    .offset(y: 4)
            }

            if shift.getTimeBlocks().isEmpty {
                plusNavigation(start: shift.start, end: shift.end)
                    .offset(y: 4)
            }

            divider(time: shift.end)
        }
    }

    func timeBlockSection(timeBlock: TimeBlock) -> some View {
        VStack(spacing: 15) {
            if startMatchesAnotherBlocksEnd(timeBlock) == false,
               let startTime = timeBlock.startTime {
                divider(time: startTime)
            }
            row(timeBlock)

            if let endTime = timeBlock.endTime {
                divider(time: endTime)

                if gaps.contains(endTime) {
                    plusNavigation(start: endTime, end: getBlockAfter(this: timeBlock)?.startTime ?? endTime)
                }
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

    @ViewBuilder func row(_ block: TimeBlock) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(block.getColor())
                .frame(width: 3)
                .padding(.vertical, 1)

            VStack(alignment: .leading) {
                Text(block.getTitle())
                    .format(size: 14, weight: .bold)
                    .lineLimit(1)

                Text(block.timeRangeString())
                    .font(.caption)
                    .lineLimit(1)
            }
            .lineLimit(1)
            Spacer()

            Text(block.amountEarned().money())
                .font(.caption)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background {
            Color.targetGray
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }

        .frame(height: 50)
    }

    func divider(time: Date) -> some View {
        HStack(spacing: 9) {
            Text(time.getFormattedDate(format: .minimalTime))
                .font(.footnote)
            VStack { Divider() }
        }
    }
}

extension ItemizedPartOfShiftView {
    func getBlockAfter(this block: TimeBlock) -> TimeBlock? {
        guard let indexOfThisBlock = shift.getTimeBlocks().firstIndex(of: block)
        else { return nil }
        return shift.getTimeBlocks().safeGet(at: indexOfThisBlock + 1)
    }

    func startMatchesAnotherBlocksEnd(_ timeBlock: TimeBlock) -> Bool {
        guard let start = timeBlock.startTime else { return false }
        for block in shift.getTimeBlocks() {
            if let end = block.endTime {
                if compareDates(start, end, accuracy: .minute) {
                    return true
                }
            }
        }
        return false
    }

    enum AccuracyLevel {
        case year
        case month
        case day
        case hour
        case minute
        case second
    }

    func compareDates(_ date1: Date, _ date2: Date, accuracy: AccuracyLevel) -> Bool {
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let dateComponents = calendar.dateComponents(components, from: date1, to: date2)

        switch accuracy {
            case .year:
                return dateComponents.year == 0
            case .month:
                return dateComponents.year == 0 && dateComponents.month == 0
            case .day:
                return dateComponents.year == 0 && dateComponents.month == 0 && dateComponents.day == 0
            case .hour:
                return dateComponents.year == 0 && dateComponents.month == 0 && dateComponents.day == 0 && dateComponents.hour == 0
            case .minute:
                return dateComponents.year == 0 && dateComponents.month == 0 && dateComponents.day == 0 && dateComponents.hour == 0 && dateComponents.minute == 0
            case .second:
                return dateComponents.year == 0 && dateComponents.month == 0 && dateComponents.day == 0 && dateComponents.hour == 0 && dateComponents.minute == 0 && dateComponents.second == 0
        }
    }
}

// MARK: - ItemizedPartOfShiftView_Previews

struct ItemizedPartOfShiftView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack(path: .constant(NavManager.shared.homeNavPath)) {
            ItemizedPartOfShiftView(shift: User.main.getShifts().first!)
                .padding()
        }
    }
}
