//
//  TodayViewWageBreakdown.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/12/23.
//

import SwiftUI
import Vin

struct TodayViewWageBreakdown: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    var shiftDuration: Double {
        viewModel.user.todayShift?.totalShiftDuration ?? 0
    }

    var hours: Double {
        shiftDuration / 60 / 60
    }

    var perHour: Double {
        guard let wageType = viewModel.user.wage?.wageType else {
            return 0
        }

        if let wage = viewModel.user.wage {
            if wageType == .salary {
                return wage.perDay / hours
            } else {
                return wage.hourly
            }
        }
        return 0
    }

    var perMinute: Double {
        perHour / 60
    }

    var perSecond: Double {
        perMinute / 60
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Period")
                Spacer()
                Text("Amount")
            }
            .foregroundStyle(UIColor.secondaryLabel.color)
            .font(.headline, design: .rounded)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 5)
            row(firstText: "Hour",
                secondText: perHour.money())
            Divider()
            row(firstText: "Minute",
                secondText: perMinute.money())
            Divider()
            row(firstText: "Second",
                secondText: perSecond.money())
        }
        .padding()
    }

    func row(firstText: String, secondText: String) -> some View {
        HStack {
            Text(firstText)

            Spacer()

            Text(secondText)
        }
        .font(.subheadline,
              design: .rounded,
              weight: .regular)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TodayViewWageBreakdown()
        .environmentObject(TodayViewModel.testing)
}
