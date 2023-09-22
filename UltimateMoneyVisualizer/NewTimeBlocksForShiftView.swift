//
//  NewTimeBlocksForShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/10/23.
//

import SwiftUI



/**
 Generates an array of `Date` objects with an hourly interval between two given dates.

 This function takes two `Date` objects, sorts them in ascending order, and generates an array of `Date` objects representing each hour between the sorted dates. The array starts one hour before the starting hour of the first date and ends one hour after the ending hour of the second date. Each date in the array is set to the beginning of the respective hour (minute and second components set to zero).

 - Parameters:
   - date1: The first `Date` object.
   - date2: The second `Date` object.

 - Returns: An array of `Date` objects representing each hour between the two given dates. Starts one hour before the earliest date and ends one hour after the latest date.

 - Note:
   - If either `Date` object contains a time component with a minute or second value, those are not considered in the array of generated dates.
   - The generated dates will have their minute and second components set to zero.

 - Example:
   ```swift
   let date1 = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
   let date2 = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!
   let dates = getHourlyDatesBetweenDates(date1: date1, date2: date2)
   // Output will be an array of dates starting from 11:00 to 15:00
   ```

 - SeeAlso:
   - `Calendar.date(bySettingHour:minute:second:of:)`
*/

func generateHourlyDatesWithinRange(from startDate: Date, to endDate: Date) -> [Date] {
    let calendar = Calendar.current
    let sortedDates = [startDate, endDate].sorted()
    let startHour = calendar.component(.hour, from: sortedDates[0])
    let endHour = calendar.component(.hour, from: sortedDates[1])
    var dates: [Date] = []
    
    for hourOffset in (startHour - 1)...(endHour + 1) {
        if let date = calendar.date(bySettingHour: hourOffset, minute: 0, second: 0, of: sortedDates[0]) {
            dates.append(date)
        }
    }
    
    return dates
}

// MARK: - NewTimeBlocksForShiftView

struct NewTimeBlocksForShiftView: View {
    let shift: Shift
    
    @Environment (\.dismiss) private var dismiss

    var body: some View {
        VStack {
            ForEach(generateHourlyDatesWithinRange(from: shift.start, to: shift.end), id: \.self) { hourDate in
                VStack {
                    HStack {
                        Text(hourDate.getFormattedDate(format: "h a")).format(size: 12, color: .textSecondary)
                        VStack {
                            Divider()
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder func row(_ block: TimeBlock) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(block.getColor())
                .frame(width: 3)
                .padding(.vertical, 5)

            VStack(alignment: .leading) {
                Text(block.getTitle())
                    .font(.callout)
                    .fontWeight(.heavy)

                Text(block.timeRangeString())
                    .format(size: 14)
                Text(block.duration.breakDownTime())
                    .format(size: 14)
            }
            .lineLimit(1)
            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Menu {
                    if let start = block.startTime,
                       start > shift.start {
                        Button {
                        } label: {
                            Label("Before", systemImage: "arrow.up").labelStyle(.titleOnly)
                        }
                    }
                    if let end = block.endTime,
                       end < shift.end {
                        Button {
                        } label: {
                            Label("After", systemImage: "arrow.down").labelStyle(.titleOnly)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            Color(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .modifier(ShadowForRect())
        }
        .frame(height: 100)
    }
}

// MARK: - NewTimeBlocksForShiftView_Previews

struct NewTimeBlocksForShiftView_Previews: PreviewProvider {
    static var previews: some View {
        NewTimeBlocksForShiftView(shift: User.main.getShifts().first!)
    }
}
