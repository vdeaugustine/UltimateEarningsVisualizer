//
//  GoalsInfoView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/27/23.
//

import SwiftUI

// MARK: - GoalsInfoView

struct GoalsInfoView: View {
    
    func pill(_ first: String, _ text: String) -> some View {
        HStack(spacing: 0) {
            Text(first)
                .bold()
            Text(text)
    //            .font(.footnote)
                
        }
        .padding(5)
        .background (
            Color(.tertiarySystemFill).clipShape(RoundedRectangle(cornerRadius: 7))
        )
        .foregroundStyle(Color(.secondaryLabel))
    }
    
    
    var body: some View {
        ScrollView {
            
            
            VStack(spacing: 20) {
                Image(systemName: "star.fill" /* IconManager.timeBlockExpanded */ )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                    .fixedSize()
                    .foregroundStyle(.tint)

                Text("Goals")
                    .font(.title)
                    .fontWeight(.semibold)
                
                VStack {
//                    Text("It stands for:")
                    HStack {
                        pill("S", "pecific")
                        pill("T", "rackable")
                        pill("A", "chievable")
                        pill("R", "elevant")
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("The S.T.A.R. goal method is a structured approach to setting meaningful and attainable objectives.")
                        .font(.subheadline)
//                        .padding()
                        .foregroundStyle(Color(.secondaryLabel))
                    
                    Text("Here is how the Goals feature utilizes this method to your benefit")
                        .font(.subheadline)
//                        .padding()
                        .foregroundStyle(Color(.secondaryLabel))
                }
                .padding(.horizontal)
                
                
                
            }

            VStack(spacing: 30) {
//

                StarRect(title: "Specific",
                         imageName: "target",
                         headline: "Title and Info",
                         bodyTexts: ["Clearly define what you want to achieve with detailed titles and additional info."])

                StarRect(title: "Trackable",
                         imageName: "chart.bar.fill",
                         headline: "Allocation & Payoff Progress",
                         bodyTexts: ["Monitor the progress of your savings or debt repayments in real-time.", "See how each saved item or work shift contributes to meeting your goals."])

                StarRect(title: "Achievable",
                         imageName: "calendar.badge.clock",
                         headline: "Due Dates & Countdowns",
                         bodyTexts: ["Set specific due dates for each financial goal or expense.", "Interactive countdowns show time left till the goal's due date.", "Visualize how much remains to save or pay off.", "Receive timely reminders as due dates approach."])

                StarRect(title: "Relevant",
                         imageName: "tag.fill",
                         headline: "Tagging & Prioritizing",
                         bodyTexts: ["Tag goals to categorize and prioritize.", "Ensure every goal aligns with life objectives.", "Receive reminders to focus on top priorities.", "Stay updated with insights on current life situation."])
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
//        .navigationTitle("S.T.A.R. Goals")
        .background {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension GoalsInfoView {
//    struct StarRow: View {
//        struct RowContent: Hashable {
//            let image: String
//            let header: String
//            let body: String
//            let example: String
//        }
//
//        let content: RowContent
//        var body: some View {
//            HStack(spacing: 16) {
//                Image(systemName: content.image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 35)
//                    .foregroundStyle(Color.blue)
//
//                VStack(alignment: .leading, spacing: 5) {
//                    Text(content.header)
//                        .font(.headline)
//                        .fontWeight(.medium)
//
//                    Text(content.body)
//                        .foregroundStyle(Color(.secondaryLabel))
//                }
//            }
//        }
//    }

    struct StarRect: View {
        let title: String
        let imageName: String
        let headline: String
        let bodyTexts: [String]

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title3)
                    .bold()

                content
            }
        }

        @ViewBuilder var content: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(headline)
                        .font(.headline)
                        .fontWeight(.medium)

                    Spacer()

                    Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundStyle(.tint)
                }

                HStack(spacing: 16) {
//                        Image(systemName: imageName)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 35)
//                            .foregroundStyle(Color.blue)

                    VStack(alignment: .leading, spacing: 5) {
                        VStack(spacing: 12) {
                            ForEach(bodyTexts, id: \.self) { text in
                                //                                HStack {
                                Text(text)
                                    //                                }
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

#Preview {
    GoalsInfoView()
//        .putInNavView(.large)
}
