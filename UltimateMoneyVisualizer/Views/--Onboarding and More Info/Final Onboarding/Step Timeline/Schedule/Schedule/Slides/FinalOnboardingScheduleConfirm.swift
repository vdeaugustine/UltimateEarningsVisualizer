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
            if viewModel.userHasRegularSchedule {
                confirmShiftTimesView(geo: geo)
            }
            else {
                otherConfirm(geo: geo)
            }
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
    
    @ViewBuilder func confirmShiftTimesView(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            TitleAndSubtitle(geo: geo)

            DaysRows
        }
        .padding(.horizontal, widthScaler(24, geo: geo))
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
    
    var mockSettings: some View {
        VStack(spacing: 0) {
            VStack {
                VStack(spacing: 42) {
                    

                    VStack(spacing: 7) {
                        Text("Money")
                            .font(.system(size: 13))
                            .foregroundStyle(UIColor.secondaryLabel.color)
                            .pushLeft()
                            .padding(.leading, 16)
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(UIColor.systemBackground.color)
                                .frame(height: 44)
                                .overlay {
                                    HStack {
//                                        Image(systemName: "bookmark.fill")
//                                            .foregroundStyle(Color.accentColor)
                                        SystemImageWithFilledBackground(systemName: "calendar")
                                        Text("Regular Schedule")
                                        Spacer()
                                        Components.nextPageChevron
                                    }
                                    .padding()
                                }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
            .background {
                UIColor.secondarySystemBackground.color
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            }

            settingsTab
        }
        .background {
            UIColor.systemBackground.color
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 1.5, x: 0, y: 1)
        }
    }

    private var settingsTab: some View {
        VStack(spacing: 7) {
            Rectangle()
                .fill(.black.opacity(0.3))
                .frame(height: 0.33)
            VStack(spacing: 7) {
                Image(systemName: "gear")
                    .font(.system(size: 28))

                Text("Settings")
            }
            .padding(.bottom, 7)
        }
        .foregroundStyle(Color.accentColor)
        .fontWeight(.medium)
        .frame(maxWidth: .infinity)
        .background {
            UIColor.systemBackground.color
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        }
    }

    private var blankContentMockSettings: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(UIColor.systemBackground.color)
                .frame(height: 44)
                .overlay {
                    HStack {
                        Spacer()
                        Components.nextPageChevron
                    }
                    .padding()
                }

            Divider()
                .padding(.leading)
            Rectangle()
                .fill(UIColor.systemBackground.color)
                .frame(height: 44)
                .overlay {
                    HStack {
                        Spacer()
                        Components.nextPageChevron
                    }
                    .padding()
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    
    private func otherConfirm(geo: GeometryProxy) -> some View {
        VStack(spacing: 50) {
            Text("You can always set your schedule in the Settings tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))
            
            mockSettings
            
            Spacer()
            
            
        }
        .padding()
    }
}

#Preview {
    FinalOnboardingScheduleConfirm()
        .environmentObject(FinalOnboardingScheduleViewModel())
        .background {
            OnboardingBackground().ignoresSafeArea()
        }
}
