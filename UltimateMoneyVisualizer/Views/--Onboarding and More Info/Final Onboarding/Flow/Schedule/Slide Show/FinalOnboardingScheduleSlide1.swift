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

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                Progress

                TitleAndContent(geo: geo)
                
                Spacer()
                
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
        Text(day.description)
            .font(.system(.headline, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background {
                UIColor.systemBackground.color
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .conditionalModifier(daysSelected.contains(day)) { thisView in
                        thisView
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 2)
                            }
                    }
            }
            .onTapGesture {
                withAnimation {
                    daysSelected.insertOrRemove(element: day)
                }
            }
    }

    @ViewBuilder var Progress: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressBar(percentage: 0.33,
                        height: 8,
                        color: Color.accentColor,
                        barBackgroundColor: UIColor.systemGray4.color,
                        showBackgroundBar: true)
            Text("STEP 1 OF 3")
                .font(.system(.title3, design: .rounded))
        }
    }

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(40, geo: geo)) {
            Text("What days of the week do you work?")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

            VStack(alignment: .leading) {
                ForEach(DayOfWeek.orderedCases) { day in
                    dayRow(day)
                }
            }
        }
    }
    
    @ViewBuilder var ContinueButton: some View {
        Button {
            
        } label: {
            Text("Continue")
                .font(.system(.headline, design: .rounded, weight: .regular))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Color.accentColor
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
        }
        
    }
}

#Preview {
    FinalOnboardingScheduleSlide1()
}
