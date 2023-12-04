//
//  ShiftSummaryBox.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/20/23.
//

import SwiftUI

// MARK: - ShiftSummaryBox

struct ShiftSummaryBox: View {
    @ObservedObject private var settings = User.main.getSettings()
    var shift: PseudoShift

    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                startTimeView
                timeAndMoneyWithDotsView
                endTimeView
            }
            .font(.callout, design: .rounded)
        }
        .groupBoxStyle(ShadowBoxGroupBoxStyle(radius: 3, x: 0, y: 2))
    }

    var startTimeView: some View {
        HStack {
            Group {
                Image(systemName: "circle")
                    .foregroundStyle(settings.themeColor)
                Text("Started")
            }
            .fontWeight(.bold)
            Spacer()
            VStack {
                Text(shift.startTime.getFormattedDate(format: "EEE MMM d"))
                    .foregroundStyle(.secondary)
                Text(shift.startTime, style: .time)
            }.fontWeight(.medium)
        }
    }

    var timeAndMoneyWithDotsView: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                ForEach(0 ..< 4, id: \.self) { _ in
                    Circle()
                        .fill(settings.themeColor)
                        .frame(width: 5)
                }
            }

            HStack {
                Text(shift.duration.breakDownTime())
                Circle()
                    .frame(width: 5)
                Text(shift.totalAmountEarned.money())
            }
            .font(.subheadline, design: .rounded)
            .foregroundStyle(.secondary)
        }
        .padding(.leading, 7)
    }

    var endTimeView: some View {
        HStack {
            Group {
                ZStack {
                    Image(systemName: "circle")
                    Image(systemName: "circle.fill")
                        .scaleEffect(0.55)
                }
                .foregroundStyle(settings.themeColor)

                Text("Ended")
            }
            .fontWeight(.bold)
            Spacer()

            VStack {
                Text(shift.endTime.getFormattedDate(format: "EEE MMM d"))
                    .foregroundStyle(.secondary)

                Text(shift.endTime, style: .time)
            }.fontWeight(.medium)
        }
    }
}

// MARK: - PseudoShiftRowView

struct PseudoShiftRowView: View {
    let shift: PseudoShift
    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        HStack {
            Text(shift.startTime.firstLetterOrTwoOfWeekday())
                .font(.body, design: .rounded)
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(settings.getDefaultGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(shift.startTime.getFormattedDate(format: .abbreviatedMonth))
                    .font(.subheadline, design: .rounded)
                    .foregroundColor(.primary)

                Text("Duration: \(shift.duration.formatForTime())")
                    .font(.caption2, design: .rounded)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text("\(shift.totalAmountEarned.money())")
                    .font(.subheadline, design: .rounded)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)

                Text("earned")
                    .font(.caption2, design: .rounded)
                    .foregroundStyle(UIColor.secondaryLabel.color)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}


#Preview {
    ShiftSummaryBox(shift: .generatePseudoShifts(hourlyWage: 20, numberOfShifts: 1).first!)
}
