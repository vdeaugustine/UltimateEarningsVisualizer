//
//  OnboardingSavedItemView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/13/23.
//

import SwiftUI

struct OnboardingSavedItemView: View {
    var body: some View {
        ScrollView {
            content
        }
    }

    private var content: some View {
        VStack(spacing: 20) {
            Spacer()
            title
            Image("savingsJar")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            VStack(alignment: .leading, spacing: 20) {
                featureSection(title: "Visualize your savings",
                               description: "Watch your saved pennies turn into substantial amounts over time!")
                featureSection(title: "Allocate Smartly",
                               description: "Use the money you save to contribute towards your expenses or your goals.")
                featureSection(title: "Celebrate Wins",
                               description: "Small savings are victories worth celebrating and they add up to big wins in the long run!")
            }
            Spacer()
            tipSection

            Spacer()
            startSavingButton
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
    }

    private var title: some View {
        Text("A penny saved is a penny earned")
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    private func featureSection(title: String, description: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .padding(.leading)
        }
    }

    private var tipSection: some View {
        Text("Quick Tip: From your daily coffee choice to seasonal sales, log every saving to keep the earning momentum going. Every bit counts towards achieving your financial goals!")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.horizontal)
    }

    private var startSavingButton: some View {
        OnboardingButton(title: "Start Saving Smartly!") {
        }
    }
}

#Preview {
    OnboardingSavedItemView()
}
