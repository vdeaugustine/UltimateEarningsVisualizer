//
//  NewTimeBlocksForShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/10/23.
//

import SwiftUI

func getHourlyDatesBetweenDates(date1: Date, date2: Date) -> [Date] {
    let calendar = Calendar.current
    let sortedDates = [date1, date2].sorted()
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

    var body: some View {
        VStack {
            ForEach(getHourlyDatesBetweenDates(date1: shift.start, date2: shift.end), id: \.self) { hourDate in
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
                    .font(.lato(16))
                    .fontWeight(.heavy)

                Text(block.timeRangeString())
                    .font(.lato(14))
                Text(block.duration.breakDownTime())
                    .font(.lato(14))
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
