//
//  ItemizedPartOfShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import SwiftUI

// MARK: - ItemizedPartOfShiftView

struct ItemizedPartOfShiftView: View {
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

    var body: some View {
        ScrollView {
            VStack {
                
                if let first = shift.getTimeBlocks().first,
                   let startOfFirst = first.startTime,
                   let shiftStart = shift.startDate,
                   startOfFirst > shiftStart {
                    NavigationLink {
                        
                      CreateNewTimeBlockView(shift: shift, start: shiftStart, end: startOfFirst)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                        
                }
                
                ForEach(shift.getTimeBlocks()) { timeBlock in
                    timeBlockSection(timeBlock: timeBlock)
                }
                
                if let last = shift.getTimeBlocks().last,
                   let endOfLast = last.endTime,
                   let shiftEnd = shift.endDate,
                   endOfLast < shiftEnd {
                    NavigationLink {
                      CreateNewTimeBlockView(shift: shift, start: endOfLast, end: shiftEnd)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                        
                }
            }
        }
    }

    func timeBlockSection(timeBlock: TimeBlock) -> some View {
        VStack(spacing: 15) {
            if startMatchesAnotherBlocksEnd(timeBlock) == false,
               let startTime = timeBlock.startTime {
                divider(time: startTime)
            }
            timeBlockPill(timeBlock: timeBlock)
            if let endTime = timeBlock.endTime {
                divider(time: endTime)
                
                if gaps.contains(endTime) {
                    NavigationLink {
                      CreateNewTimeBlockView(shift: shift,
                                             start: endTime,
                                             end: getBlockAfter(this: timeBlock)?.startTime ?? endTime )
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .padding(.top, -15)
                    }
                    
                }
            }
            
            
            
        }
    }

    func timeBlockPill(timeBlock: TimeBlock) -> some View {
        HStack {
            if let title = timeBlock.title {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Color.black)

                Spacer()

                Text(timeBlock.amountEarned().formattedForMoney())
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#003649"))
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: "#F9DB8C"))
        }
    }

    func divider(time: Date) -> some View {
        HStack(spacing: 9) {
            Text(time.getFormattedDate(format: .minimalTime))
            Rectangle()
                .frame(height: 2.5)
                .foregroundColor(Color.black)
                .cornerRadius(2)
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
        ItemizedPartOfShiftView(shift: User.main.getShifts().first!)
            .padding()
            .putInNavView(.inline)
    }
}
