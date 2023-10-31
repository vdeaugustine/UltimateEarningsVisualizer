//
//  ShiftInfoView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/30/23.
//

import SwiftUI

struct ShiftInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                        Text("Allows you to predict where you will be in the future if you have a regular work schedule")
                            .font(.subheadline)
                            .foregroundStyle(Color(.secondaryLabel))

                        Text("Can be broken down into time blocks to see how your earnings are allocated")
                            .font(.subheadline)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 5) {
                    Text("How it works")
                        .font(.title3)
                        .bold()

                    VStack(alignment: .leading, spacing: 12) {
                        Group {
                            Text("• Enter your start and end times for the shift")
                            Text("• Uses your wage settings to determine how much you earned for that shift")

                            Text("• Adds the total money you earned for that shift to your earnings amount")

                            Text("• Your earnings can be used to pay off your expenses and goals")
                        }

//                                .foregroundStyle(Color(.secondaryLabel))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()

                    .background {
                        Color(.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            }
        }
        .background {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    struct Rect: View {
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
    ShiftInfoView()
}
