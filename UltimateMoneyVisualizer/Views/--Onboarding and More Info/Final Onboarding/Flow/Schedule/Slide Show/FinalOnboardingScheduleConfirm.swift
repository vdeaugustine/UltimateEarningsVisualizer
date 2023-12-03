//
//  FinalOnboardingScheduleConfirm.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/2/23.
//

import SwiftUI

struct FinalOnboardingScheduleConfirm: View {
    @EnvironmentObject private var viewModel: FinalOnboardingScheduleViewModel

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                TitleAndSubtitle(geo: geo)

                DaysRows
            }
            .padding(.horizontal, widthScaler(24, geo: geo))
        }
        
        .fontDesign(.rounded)
        .fullScreenCover(item: $viewModel.highlightedDay) {
            viewModel.highlightedDay = nil
        } content: { _ in
            FinalOnboardingHoursForDay()
                .background {
                    OnboardingBackground()
                        .ignoresSafeArea()
                }
        }

    }

    func TitleAndSubtitle(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(30, geo: geo)) {
            Text("Your Schedule")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))
                .layoutPriority(2)
            Text("Tap any day to edit it")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
    
    var DaysRows: some View {
        ForEach(viewModel.daysSelected) { day in
            Button {
                viewModel.highlightedDay = day
            } label: {
                HStack {
                    Text(day.description)

                    Spacer()

                    VStack {
                        Text(viewModel.getStartTime(for: day).getFormattedDate(format: .minimalTime, amPMCapitalized: false))
                        Text(viewModel.getEndTime(for: day).getFormattedDate(format: .minimalTime, amPMCapitalized: false))
                    }
                    
                    Components.nextPageChevron.padding(.leading)
                }
                .padding()
                .background {
                    UIColor.systemBackground.color
                        .opacity(0.35)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    FinalOnboardingScheduleConfirm()
        .environmentObject(FinalOnboardingScheduleViewModel())
        .background {
            OnboardingBackground().ignoresSafeArea()
        }
}
