//
//  OnboardingFirstView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/25/23.
//

import SwiftUI

// MARK: - OnboardingFirstView

struct OnboardingFirstView: View {
    @StateObject private var model = OnboardingModel.shared
    @StateObject private var manager = OnboardingManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var tab: Int = 1
    @State private var wageIsGood = false

    var body: some View {
        TabView(selection: $model.screenNumber) {
            WelcomeView()
                .tag(1)

            FeaturesListView()
                .tag(2)

            OnboardingWageWalkthrough()
                .tag(3)

            if model.wageWasSet {
                OnboardingRegularDaysView()
                    .tag(4)

                WhatIsASavedItem()
                    .tag(5)
                
                GoalsOnboardingView()
                    .tag(6)
            }
        }
//        .onChange(of: model.screenNumber) { new in
//            if new > 2 {
//                model.screenNumber = 2
//                print("new")
//            }
//        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(model.backgroundColor.ignoresSafeArea())
        .environmentObject(model)
        .environmentObject(manager)
    }

    @ViewBuilder var first: some View {
        VStack {
            Spacer()

            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 85)
                .foregroundColor(.gray)

            VStack(spacing: 14) {
                Text("Welcome!")
                    .font(.largeTitle, design: .rounded)
                    .fontWeight(.semibold)

                Text("We will walk you through the steps of getting set up.")
                    .fontDesign(.rounded)
                    .fontWeight(.medium)
            }

            Spacer()

            Button("Lets go!") {
                print("tapped")
                model.increaseScreenNumber()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding()
        .background(model.backgroundColor.ignoresSafeArea())
    }

    @ViewBuilder var arrows: some View {
        HStack {
            if tab > 1 {
                Button(action: {
                    model.decreaseScreenNumber()
                }) {
                    HStack {
                        Text("Previous")
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                        Image(systemName: "arrow.left")
                    }
                    .padding()
                    .cornerRadius(10)
                }
            }

            Spacer()

            Button(action: {
                model.increaseScreenNumber()
            }) {
                HStack {
                    Text("Next")
                        .fontWeight(.medium).fontDesign(.rounded)
                    Image(systemName: "arrow.right")
                }
                .padding()
                .cornerRadius(10)
            }
        }
    }
}

// MARK: - OnboardingFirstView_Previews

struct OnboardingFirstView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFirstView()
    }
}
