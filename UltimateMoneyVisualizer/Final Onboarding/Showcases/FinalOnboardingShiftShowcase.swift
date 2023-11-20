//
//  FinalOnboardingShiftShowcase.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/19/23.
//

import SwiftUI
import Vin

// MARK: - PseudoShift

struct PseudoShift: Hashable {
    var startTime: Date
    var endTime: Date
    var hourlyWage: Double

    // Computed property to calculate duration in hours
    var duration: Double {
        endTime - startTime // Converts seconds to hours
    }

    // Computed property to calculate total amount earned
    var totalAmountEarned: Double {
        duration / 60 / 60 * hourlyWage
    }

    // Function to generate pseudo shifts
    static func generatePseudoShifts(hourlyWage: Double, numberOfShifts: Int) -> [PseudoShift] {
        var shifts: [PseudoShift] = []

        for i in 0 ..< numberOfShifts {
            let calendar = Calendar.current
            let yesterday = calendar.date(byAdding: .day, value: -i, to: Date())!
            let startHour = (i % 2 == 0) ? 9 : 10
            let startMinute = (i % 2 == 0) ? 0 : 30
            let startTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: yesterday)!
            let endTime = calendar.date(byAdding: .hour, value: 8, to: startTime)!

            let shift = PseudoShift(startTime: startTime, endTime: endTime, hourlyWage: hourlyWage)
            shifts.append(shift)
        }

        return shifts
    }
}

// MARK: - FinalOnboardingShiftShowcase

struct FinalOnboardingShiftShowcase: View {
    @ObservedObject private var user = User.main

    let shifts = PseudoShift.generatePseudoShifts(hourlyWage: 20, numberOfShifts: 3)

    var body: some View {
        ScrollView {
            
            VStack {
                Spacer()
                titleAndSubtitle
                    .padding([.horizontal])

//                bonus
//                    .padding(.horizontal)

                Spacer(minLength: 40)

                recentShifts

                Spacer(minLength: 70)
            }
            .frame(maxHeight: .infinity)
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 24) {
                
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Image(systemName: "lightbulb")
                            .foregroundStyle(.yellow)
                        Text("Bonus:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Text("You can simulate shifts you haven't worked yet to project your finances in the future")
                        .font(.footnote)
                        .layoutPriority(1)
                }
                .padding(.horizontal)
                
                OnboardingButton(title: "Great!", height: 50) {
                }
                .padding(.horizontal, 30)
            }
            .padding(.bottom)
        }
    }

    var bonus: some View {
        GroupBox {
            Text("You can simulate shifts you haven't worked yet to project your finances in the future")
                .font(.footnote)
                .layoutPriority(1)

        } label: {
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundStyle(.yellow)
                Text("Bonus:")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .groupBoxStyle(
            ShadowBoxGroupBoxStyle(headerContentSpacing: 5,
                                   paddingInsets: nil)
        )
//        .padding(.horizontal)
//        .padding()
    }

    var titleAndSubtitle: some View {
        VStack(spacing: 30) {
            Text("Creating Shifts to Track Your Work Days")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            VStack(spacing: 10) {
                Text("Keeping track of every day you work allows you to see your money earned in real time, instead of waiting for your next paycheck")
            }
            .foregroundStyle(.secondary)
            .lineSpacing(3)
        }
//        .padding(.horizontal, 20)
    }

    var recentShifts: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 7) {
                Text("Recent Shifts")
                    .font(.title3).fontWeight(.semibold)
                ShiftSummaryBox(shift: PseudoShift.generatePseudoShifts(hourlyWage: 20, numberOfShifts: 1).first!)
                    .padding(.horizontal, 3)
            }

            VStack {
                ForEach(shifts.dropFirst(), id: \.self) { shift in
                    PseudoShiftRowView(shift: shift)
                }
            }
        }
//        .padding()
        .fadeEffect(startPoint: .center)
    }
}

// MARK: - PseudoShiftRowView

struct PseudoShiftRowView: View {
    let shift: PseudoShift
    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        HStack {
            Text(shift.startTime.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(settings.getDefaultGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(shift.startTime.getFormattedDate(format: .abbreviatedMonth))
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text("Duration: \(shift.duration.formatForTime())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text("\(shift.totalAmountEarned.money())")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)

                Text("earned")
                    .font(.caption2)
                    .foregroundStyle(UIColor.secondaryLabel.color)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

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
            .font(.callout)
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
                    .fontWeight(.medium)
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
            .font(.subheadline)
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

// Extension to apply the modifier easily
extension View {
    func fadeEffect(startOpacity: Double = 1,
                    endOpacity: Double = 0,
                    startPoint: UnitPoint = .center,
                    endPoint: UnitPoint = .bottom)
        -> some View {
        modifier(
            FadeEffectModifier(startOpacity: startOpacity,
                               endOpacity: endOpacity,
                               startPoint: startPoint,
                               endPoint: endPoint)
        )
    }
}

// MARK: - FadeEffectModifier

// Custom ViewModifier for fading effect
struct FadeEffectModifier: ViewModifier {
    var startOpacity: Double = 1
    var endOpacity: Double = 0
    var startPoint: UnitPoint = .center
    var endPoint: UnitPoint = .bottom

    func body(content: Content) -> some View {
        content
            .mask(
                LinearGradient(gradient: Gradient(stops: [.init(color: Color.white.opacity(startOpacity), location: 0),
                                                          .init(color: Color.white.opacity(endOpacity), location: 1)]),
                startPoint: startPoint,
                endPoint: endPoint)
            )
    }
}

// MARK: - ShadowBoxGroupBoxStyle

struct ShadowBoxGroupBoxStyle: GroupBoxStyle {
    var radius: CGFloat = 5
    var x: CGFloat = 0
    var y: CGFloat = 2
    var headerContentSpacing: CGFloat = 15
    var paddingInsets: EdgeInsets? = nil
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: headerContentSpacing) {
            configuration.label
                .fontWeight(.semibold)
            configuration.content
        }
        .frame(maxWidth: .infinity)
        .conditionalModifier(paddingInsets == nil) { view in
            view.padding()
        }
        .conditionalModifier(paddingInsets != nil) { view in
            view.padding(paddingInsets!)
        }
        // Add padding around the content
        .background(Color.white) // Set the background color to white
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: radius, x: x, y: y) // Adds shadow
    }
}

// MARK: - OutlineBoxGroupBoxStyle

struct OutlineBoxGroupBoxStyle: GroupBoxStyle {
    var color: Color = .secondary
    var lineWidth: CGFloat = 1
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            configuration.label
                .fontWeight(.semibold)
            configuration.content
        }
        .frame(maxWidth: .infinity)
        .padding() // Add padding around the content
        .background(Color.white) // Set the background color to white
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(color, lineWidth: lineWidth)
        }
    }
}

#Preview {
    FinalOnboardingShiftShowcase()
}
