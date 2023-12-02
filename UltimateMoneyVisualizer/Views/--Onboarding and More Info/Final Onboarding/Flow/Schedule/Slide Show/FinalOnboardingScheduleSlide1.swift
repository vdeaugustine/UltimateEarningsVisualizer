//
//  FinalOnboardingScheduleSlide1.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/27/23.
//

import SwiftUI
import Vin

struct FinalOnboardingScheduleSlide1: View {
    @State private var daysSelected: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                ScrollView {
                    TitleAndContent(geo: geo)
                }
                .scrollIndicators(.hidden)

            }
            .padding(.horizontal, widthScaler(24, geo: geo))
        }
    }

    @ViewBuilder func dayRow(_ day: DayOfWeek) -> some View {
        Text(day.description)
            .font(.system(.headline, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background {
                UIColor.systemBackground.color
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(0.35)
                    .conditionalModifier(daysSelected.contains(day)) { thisView in
                        thisView
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 2)
                            }
                    }
            }
            .padding(.horizontal, 2)
            .onTapGesture {
                withAnimation {
                    daysSelected.insertOrRemove(element: day)
                }
            }
    }

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(40, geo: geo)) {
            Text("What days of the week do you work?")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))
                .layoutPriority(2)

            VStack(alignment: .leading) {
                ForEach(DayOfWeek.orderedCases) { day in
                    dayRow(day)
                }
            }
        }
    }
}

#Preview {
    FinalOnboardingScheduleSlide1()
}
