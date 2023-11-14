//
//  SecondSlideShow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/12/23.
//

import SwiftUI

struct SecondSlideShow: View {
    @State private var tab: Int = 2
    var body: some View {
        TabView(selection: $tab) {
            VStack {
                Image("welcomePlaceholderClear")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 50)

                VStack(spacing: 20) {
                    Text("Welcome to your Money Visualizer!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("Embark on a journey to financial clarity and freedom.")
                        .font(.headline)
                        .fontWeight(.regular)
                }
                .padding(.horizontal)
            }
            .tag(0)

            VStack {
                Image("expense")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 50)

                VStack(spacing: 20) {
                    Text("Track Your Earnings and Spending")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("Easily link income sources and monitor expenses in one place.")
                        .font(.headline)
                        .fontWeight(.regular)
                }
                .padding(.horizontal)
            }
            .tag(1)

            VStack {
                Image("goalJar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 50)

                VStack(spacing: 20) {
                    Text("Set and Achieve Financial Goals")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("Plan for your dreams, from vacations to savings.")
                        .font(.headline)
                        .fontWeight(.regular)
                }
                .padding(.horizontal)
            }

            .tag(2)

            ExampleShiftRow
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    var ExampleShiftRow: some View {
        HStack {
            Text(Date.now.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(Color.defaultColorOptions.first!.getGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(Date.nineAM.getFormattedDate(format: .abbreviatedMonth))
                    .font(.subheadline)
                    .foregroundColor(UIColor.label.color)

                Text("Duration: \(Double(8 * 60 * 60).formatForTime())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text("$$$")
                    .font(.subheadline)
                    .foregroundColor(UIColor.label.color)
                    .multilineTextAlignment(.trailing)

                Text("earned")
                    .font(.caption2)
                    .foregroundStyle(UIColor.secondaryLabel.color)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding()
        .background {
            UIColor.secondarySystemBackground.color
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SecondSlideShow()
//        .preferredColorScheme(.dark)
}
