//
//  FinalOnboardingScheduleSlide2.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/27/23.
//

import SwiftUI

// MARK: - FinalOnboardingScheduleSlide2

struct FinalOnboardingScheduleSlide2: View {
    @State private var daysSelected: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    
    @State private var sameHoursDays: [DayOfWeek] = []

    @State private var mondayStart: Date = .nineAM
    @State private var mondayEnd: Date = .fivePM

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                Progress

                TitleAndContent(geo: geo)

                Spacer()

                IncludedDays
                ContinueButton
            }
            .padding(.horizontal, widthScaler(24, geo: geo))
        }

        .background {
            OnboardingBackground()
                .ignoresSafeArea()
        }
    }

    @ViewBuilder func dayRow(_ day: DayOfWeek) -> some View {
        VStack(alignment: .leading) {
        }
//        Text(day.description)
//            .font(.system(.headline, design: .rounded))
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding()
//            .background {
//                UIColor.systemBackground.color
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .conditionalModifier(daysSelected.contains(day)) { thisView in
//                        thisView
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.accentColor, lineWidth: 2)
//                            }
//                    }
//            }
//            .onTapGesture {
//                withAnimation {
//                    daysSelected.insertOrRemove(element: day)
//                }
//            }
    }

    @ViewBuilder var Progress: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressBar(percentage: 0.67,
                        height: 8,
                        color: Color.accentColor,
                        barBackgroundColor: UIColor.systemGray4.color,
                        showBackgroundBar: true)
            Text("STEP 2 OF 3")
                .font(.system(.title3, design: .rounded, weight: .medium))
        }
    }

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(40, geo: geo)) {
            Text("What hours do you work on \((daysSelected.first ?? .monday).description)s?")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

            VStack(alignment: .leading) {
                DatePicker(selection: $mondayStart, displayedComponents: .hourAndMinute) {
                    Text("Start Time")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .padding()
                }
                .controlSize(.large)
                DatePicker(selection: $mondayEnd, displayedComponents: .hourAndMinute) {
                    Text("End Time")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .padding()
                }
                .controlSize(.large)

//               Text("Start Time")
//                    .font(.system(.title2, design: .rounded, weight: .semibold))
//                    .padding()

//                Text("9:00 AM")
//                    .font(.system(.title, design: .rounded, weight: .bold))
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background {
//                        UIColor.systemBackground.color
//                            .overlay(.regularMaterial)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .shadow(radius: 7)
//
//                    }
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
                    ForEach(daysSelected.sorted(by: <).dropFirst()) { day in
                        Text(day.description)
                            .padding(20, 10)
                            .background {
                                UIColor.systemBackground.color
                                    .clipShape(Capsule())
                                    .conditionalModifier(sameHoursDays.contains(day)) { thisView in
                                        thisView
                                            .overlay {
                                                Capsule()
                                                    .stroke(Color.accentColor, lineWidth: 2)
                                            }
                                    }
                            }
                            .onTapGesture {
                                withAnimation {
                                    sameHoursDays.insertOrRemove(element: day)
                                }
                            }
                    }
                }
                .padding()
            }
                            label: {
                Text("Apply these hours to multiple days")
            }
        }
    }

    @ViewBuilder var ContinueButton: some View {
        Button {
        } label: {
            Text("Continue")
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
    FinalOnboardingScheduleSlide2()
        .controlSize(.large)
}
