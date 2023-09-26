//
//  PurchasePage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/7/23.
//

import SwiftUI

// MARK: - PurchasePage

struct PurchasePage: View {
    let benefitsList: [String] = ["Unlimited items", "Customizable theme", "Customize icon", "More graphs and stats", "Support an independent developer!"]

    @State private var selectedItem: SelectedItem = .trial
    @ObservedObject private var user = User.main
    @ObservedObject private var settings = User.main.getSettings()
    @State private var currentPlan = SelectedItem.trial

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                benefitsListWithImage
                    .padding(.bottom)
                options
                    .padding(.vertical)
                    .centerInParentView()

                VStack(spacing: 30) {
                    button
                    footer
                }

                Spacer()
            }
        }
        .padding()
        .putInTemplate()
        .navigationTitle("Subscription")
        .background(
            Color.listBackgroundColor
        )
    }

    var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Go Premium")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(settings.themeColor)
                Text("Benefits of Premium")
                    .font(.title)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
    }

    var benefitsListWithImage: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(benefitsList, id: \.self) { benefit in
                    HStack {
                        Circle()
                            .fill(settings.themeColor)
                            .frame(width: 10)

                        Text(benefit)
                    }
                }
            }
            Spacer()
        }
    }

    var options: some View {
        HStack(alignment: .bottom) {
            ForEach(SelectedItem.allCases, id: \.self) { option in
                VStack(spacing: 5) {
                    if option == currentPlan {
                        Text("Current")
                            .foregroundStyle(Color.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background {
                                Capsule()
                                    .foregroundStyle(settings.getDefaultGradient())
                            }
                    }

                    OptionRect(thisItem: option, selectedItem: $selectedItem)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    enum SelectedItem: String, CaseIterable, Hashable {
        case trial, monthly, yearly
        var amount: String {
            switch self {
                case .trial:
                    return "Free"
                case .monthly:
                    return 5.money(includeCents: false)
                case .yearly:
                    return 50.money(includeCents: false)
            }
        }

        var cadence: String {
            switch self {
                case .trial:
                    return "7 day free trial"
                case .monthly:
                    return "per month"
                case .yearly:
                    return "per year"
            }
        }
    }

    struct OptionRect: View {
        let thisItem: SelectedItem
        @Binding var selectedItem: SelectedItem
        var isSelected: Bool { thisItem == selectedItem }
        @ObservedObject private var settings = User.main.getSettings()

        var backGround: AnyView {
            if isSelected {
                return RoundedRectangle(cornerRadius: 8)
                    .fill(settings.getDefaultGradient())
                    .shadow(radius: 2)
                    .anyView
            } else {
                return RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(radius: 2)
                    .anyView
            }
        }

        var body: some View {
            Button {
                withAnimation {
                    selectedItem = thisItem
                }

            } label: {
                ZStack {
                    backGround

                    VStack(alignment: .leading) {
                        Text(thisItem.amount)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(isSelected ? .white : .black)
                        Text(thisItem.cadence)
                            .font(.subheadline)
                            .foregroundColor(isSelected ? .white : .secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 130)
//                .aspectRatio(0.8, contentMode: .fit)
            }
//            .buttonStyle(.plain)
        }
    }

    var button: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Try premium for 7 days FREE")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button {
                    currentPlan = selectedItem
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(stops: [.init(color: settings.themeColor, location: 0),
                                                       .init(color: settings.themeColor.getLighterColorForGradient(30),
                                                             location: 1.5)],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                            )
                        Text("Select")
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .shadow(radius: 1)
                }
            }

            Button {
            } label: {
                Text("Restore Premium")
                    .font(.headline)
                    .foregroundColor(.hexStringToColor(hex: "#5c5c5c"))
            }
        }
    }

    var footer: some View {
        Text("Ultimate Money Visualizer is designed, built, and maintained entirely by a single independent app developer. Any purchase helps keep the app going and makes improvements possible.")
            .font(.subheadline)

            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.712))
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(99)
    }
}

// MARK: - GoPremiumView_Previews

struct GoPremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasePage()
            .putInNavView(.inline)
    }
}
