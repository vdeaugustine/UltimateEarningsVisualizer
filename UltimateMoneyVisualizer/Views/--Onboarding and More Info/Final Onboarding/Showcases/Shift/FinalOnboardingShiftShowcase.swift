//
//  FinalOnboardingShiftShowcase.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/19/23.
//

import SwiftUI
import Vin

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
                            .font(.subheadline, design: .rounded)
                            .fontWeight(.medium)
                    }
                    
                    Text("You can simulate shifts you haven't worked yet to project your finances in the future")
                        .font(.footnote, design: .rounded)
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
                .font(.footnote, design: .rounded)
                .layoutPriority(1)

        } label: {
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundStyle(.yellow)
                Text("Bonus:")
                    .font(.subheadline, design: .rounded)
                    .fontWeight(.medium)
            }
        }
        .groupBoxStyle(
            ShadowBoxGroupBoxStyle(headerContentSpacing: 5,
                                   paddingInsets: nil)
        )
    }

    var titleAndSubtitle: some View {
        VStack(spacing: 30) {
            Text("Creating Shifts to Track Your Work Days")
                .font(.title, design: .rounded)
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            VStack(spacing: 10) {
                Text("Keeping track of every day you work allows you to see your money earned in real time, instead of waiting for your next paycheck")
                    .font(.body, design: .rounded)
            }
            .foregroundStyle(.secondary)
            .lineSpacing(3)
        }
    }

    var recentShifts: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 7) {
                Text("Recent Shifts")
                    .font(.title3, design: .rounded, weight: .semibold)
                ShiftSummaryBox(shift: PseudoShift.generatePseudoShifts(hourlyWage: 20, numberOfShifts: 1).first!)
                    .padding(.horizontal, 3)
            }

            VStack {
                ForEach(shifts.dropFirst(), id: \.self) { shift in
                    PseudoShiftRowView(shift: shift)
                }
            }
        }
        .fadeEffect(startPoint: .center)
    }
}



#Preview {
    FinalOnboardingShiftShowcase()
}
