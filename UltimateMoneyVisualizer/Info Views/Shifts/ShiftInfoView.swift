//
//  ShiftInfoView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/30/23.
//

import SwiftUI

// MARK: - ShiftInfoView

struct ShiftInfoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Image(systemName: "calendar" /* IconManager.timeBlockExpanded */ )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                        .fixedSize()
                        .foregroundStyle(.tint)

                    Text("Shifts")
                        .font(.system(.largeTitle, weight: .bold))
                        .frame(maxWidth: 350)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Shifts are the building blocks of your financial tracking.")
                    }

                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))
                    .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 20) {
                    Text("Enter your hours for the workday to get your earnings for that shift")
                        .fontWeight(.medium)
                    VStack(alignment: .leading, spacing: 10) {
                        DatePicker("Start time", selection: .constant(Date.getThisTime(hour: 9, minute: 0) ?? .now))
                            .allowsHitTesting(false)
                        Divider().padding(.leading)
                        DatePicker("End time", selection: .constant(Date.getThisTime(hour: 17, minute: 0) ?? .now))
                            .allowsHitTesting(false)
                        Divider().padding(.leading)
                        Text("Duration")
                            .spacedOut(text: "8h")
                        Divider().padding(.leading)
                        Text("Earnings")
                            .spacedOut(text: "$160.00")
                    }
                    .padding(.vertical)
//                    .padding()
//                    .modifier(ShadowForRect())
                }
                .padding()
                .background {
                    UIColor.systemBackground.color.clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Itemize your shift by creating time blocks")
                        .fontWeight(.medium)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            if let firstStart = Date.getThisTime(hour: 9, minute: 0),
                               let firstEnd = Date.getThisTime(hour: 9, minute: 45) {
                                ExampleTimeBlockCompact(title: "Checked email",
                                                        start: firstStart,
                                                        end: firstEnd)
                            }

                            if let firstStart = Date.getThisTime(hour: 10, minute: 0),
                               let firstEnd = Date.getThisTime(hour: 11, minute: 30) {
                                ExampleTimeBlockCompact(title: "Meetings",
                                                        start: firstStart,
                                                        end: firstEnd,
                                                        color: .red)
                            }

                            if let firstStart = Date.getThisTime(hour: 12, minute: 30),
                               let firstEnd = Date.getThisTime(hour: 14, minute: 0) {
                                ExampleTimeBlockCompact(title: "Focused work",
                                                        start: firstStart,
                                                        end: firstEnd,
                                                        color: .yellow)
                            }
                        }
                        .padding()
                    }
                }
                .padding()
                .background {
                    UIColor.systemBackground.color.clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Use your earnings to payoff ") + Text("Goals").bold() + Text(" and ") + Text("Expenses").bold()
                    PseudoAllocationSummaryView(amount: 150, sourceTitle: "Shift for 11/7/23", expenseTitle: "Car payment")
                        .modifier(ShadowForRect())
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(UIColor.systemFill.color, lineWidth: 1)
//                        }
                }
                .padding()
                .background {
                    UIColor.systemBackground.color.clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical)
        .presentationDetents([.fraction(0.999)])
        .background {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    struct RectSection: View {
        let title: String?
        let imageName: String?
        let headline: String?
        let bodyTexts: [String]

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                if let title {
                    Text(title)
                        .font(.title3)
                        .bold()
                }

                content
            }
            .padding(.horizontal)
        }

        @ViewBuilder var content: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    if let headline {
                        Text(headline)
                            .font(.headline)
                            .fontWeight(.medium)
                        Spacer()
                    }

                    if let imageName {
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .foregroundStyle(.tint)
                    }
                }

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 5) {
                        VStack(spacing: 12) {
                            ForEach(bodyTexts, id: \.self) { text in
                                Text(text)
                                    .foregroundStyle(Color(.secondaryLabel))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
            .padding()

            .background {
                Color(.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

// MARK: - PseudoAllocationSummaryView

struct PseudoAllocationSummaryView: View {
    // MARK: - Body

    let amount: Double
    let sourceTitle: String
    let expenseTitle: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Allocation")
                Spacer()
                Text(amount.money())
            }
            .fontWeight(.semibold)
            .kerning(0.7)

            HStack {
                HStack(alignment: .top) {
                    ConnectedCirclesView(lineWidth: 2)
                        .frame(width: 12)
                        .padding(.vertical, 4)
                        .frame(maxHeight: .infinity)

                    VStack(alignment: .leading) {
                        Text(sourceTitle)
                        Spacer()

                        Text(expenseTitle)
                    }
                }
                .frame(height: 60)

                Spacer()

//                Text(allocation.amount.money())
            }
        }
        .modifier(Modifiers())
    }

    // MARK: - Modifiers

    struct Modifiers: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
        }
    }

}

#Preview {
    ShiftInfoView()
}
