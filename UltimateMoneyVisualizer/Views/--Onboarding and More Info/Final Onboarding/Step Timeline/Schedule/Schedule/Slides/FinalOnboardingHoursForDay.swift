//
//  FinalOnboardingHoursForDay.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/27/23.
//

import SwiftUI

// MARK: - FinalOnboardingHoursForDay

struct FinalOnboardingHoursForDay: View {
    @EnvironmentObject private var viewModel: FinalOnboardingScheduleViewModel

    @State private var startTime: Date = .nineAM
    @State private var endTime: Date = .fivePM
    
    @Environment (\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                if let day = viewModel.highlightedDay {
                    TitleAndContent(day: day, geo: geo)
                    Spacer()

                    EnterButton(day: day)
                }
            }
            .padding(.horizontal, widthScaler(24, geo: geo))
        }

        .onAppear(perform: {
            if let highlightedDay = viewModel.highlightedDay {
                let start = viewModel.getStartTime(for: highlightedDay)
                let end = viewModel.getEndTime(for: highlightedDay)

                startTime = start
                endTime = end

                print("Set")
            }
        })
        .onChangeProper(of: viewModel.highlightedDay) {
            if let highlightedDay = viewModel.highlightedDay {
                let start = viewModel.getStartTime(for: highlightedDay)
                let end = viewModel.getEndTime(for: highlightedDay)

                startTime = start
                endTime = end

                print("highlighted day")
            }
        }
    }

    func TitleText(day: DayOfWeek, geo: GeometryProxy) -> some View {
        let dayName = day.description + "s"

        var attributedText = AttributedString("What hours do you work on \(dayName)?")

        if let range = attributedText.range(of: dayName) {
            attributedText[range].foregroundColor = .accentColor
        }

        return Text(attributedText)
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, widthScaler(96, geo: geo))
    }

    @ViewBuilder func TitleAndContent(day: DayOfWeek, geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 40) {
            TitleText(day: day, geo: geo)

            VStack(alignment: .leading, spacing: 35) {
                DatePicker(selection: $startTime, displayedComponents: .hourAndMinute) {
                    Text("Start Time")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                }
                .controlSize(.large)

                DatePicker(selection: $endTime, displayedComponents: .hourAndMinute) {
                    Text("End Time")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                }
                .controlSize(.large)
            }
        }
    }

    @ViewBuilder var IncludedDays: some View {
        VStack {
            DisclosureGroup {
                LazyVGrid(columns: GridItem.flexibleItems(2),
                          alignment: .leading,
                          spacing: 10,
                          pinnedViews: []) {
                    ForEach(viewModel.getDaysSelectedExcept()) { day in
                        Text(day.description)
                            .padding(20, 10)
                            .background {
                                UIColor.systemBackground.color
                                    .clipShape(Capsule())
                                    .conditionalModifier(viewModel.sameHoursDays.contains(day)) { thisView in
                                        thisView
                                            .overlay {
                                                Capsule()
                                                    .stroke(Color.accentColor, lineWidth: 2)
                                            }
                                    }
                            }
                            .onTapGesture {
                                withAnimation {
                                    viewModel.toggleSameDaySelection(day)
                                }
                            }
                    }
                }
                .padding()
            } label: {
                Text("Apply these hours to multiple days")
            }
        }
    }

    @ViewBuilder func EnterButton(day: DayOfWeek) -> some View {
        Button {
            viewModel.setStartTime(for: day, to: startTime)
            viewModel.setEndTime(for: day, to: endTime)
            dismiss()
        } label: {
            Text("Enter")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Color.accentColor
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
        }
    }

    func widthScaler(_ width: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameWidth = geo.size.width
        let coefficient = frameWidth / 430
        return coefficient * width
    }

    func heightScaler(_ height: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameHeight = geo.size.height
        let coefficient = frameHeight / 932
        return coefficient * height
    }
}

#Preview {
    FinalOnboardingHoursForDay()
        .environmentObject(FinalOnboardingScheduleViewModel.testing)
        .onAppear {
            FinalOnboardingScheduleViewModel.testing.highlightedDay = .wednesday
        }
}
