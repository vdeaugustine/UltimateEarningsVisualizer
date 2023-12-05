//
//  PopoverContents.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/14/23.
//

import SwiftUI

// MARK: - PopoverContents

struct PopoverContents: View {
    @ObservedObject private var settings = User.main.getSettings()

    let texts: [String]
    var height: CGFloat? = nil
    var buttonTitle: String? = nil
    var buttonAction: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    ForEach(texts, id: \.self) {
                        Text($0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                .font(.subheadline)

//                .border(.yellow)
            }

            if let buttonTitle,
               let buttonAction {
                Button(buttonTitle, action: buttonAction)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    .padding([.top, .trailing])
//                    .border(.green)
            }
        }
//        .frame(maxWidth: .infinity)
        .padding(10)
        .foregroundStyle(.white)
        .frame(height: height ?? 170)
//        .border(.red)
        .background {
            settings.themeColor.getGradient()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(-20)
        }
    }
}

// MARK: - Totals_HomeView_Popover

struct Totals_HomeView_Popover: View {
    var buttonAction: (() -> Void)?
    var body: some View {
        PopoverContents(texts: ["Here you will see your totals to date for each categoy"],
                        height: 110,
                        buttonTitle: "Next",
                        buttonAction: buttonAction)
    }
}

// MARK: - NetMoney_HomeView_Popover

struct NetMoney_HomeView_Popover: View {
    var buttonAction: (() -> Void)?
    var body: some View {
        PopoverContents(texts: ["This graph shows your net money over time.",
                                "It takes into account your earnings + saved items and your payoff items"],
                        height: 133,
                        buttonTitle: "Next",
                        buttonAction: buttonAction)
    }
}

// MARK: - PayoffQueue_HomeView_Popup

struct PayoffQueue_HomeView_Popup: View {
    var buttonAction: (() -> Void)?
    var body: some View {
        PopoverContents(texts: ["Your Payoff Queue automatically utilizes every penny you earn in real-time to chip away at your expenses and goals!",
                                "Watch your queued items get paid off, keeping your financial journey smoothly on track.",
                                "Simply prioritize, and your earnings handle the rest!"],
                        height: 250,
                        buttonTitle: "Next",
                        buttonAction: buttonAction)
    }
}

// MARK: - WageBreakdown_HomeView_Popover

struct WageBreakdown_HomeView_Popover: View {
    var buttonAction: (() -> Void)?
    var body: some View {
        PopoverContents(texts: ["Below is your wage breakdown for each unit of time",
                                "Tap on the 'taxes' button to see your earnings before or after taxes"],
                        height: 170,
                        buttonTitle: "Next",
                        buttonAction: buttonAction)
    }
}

// MARK: - TimeBlock_HomeView_Popover

struct TimeBlock_HomeView_Popover: View {
    var buttonAction: (() -> Void)?
    var body: some View {
        PopoverContents(texts: ["Here you will see your most used Time Blocks"],
                        height: 90,
                        buttonTitle: "Next",
                        buttonAction: buttonAction)
    }
}

// MARK: - QuickAddButton_HomeView_Popover

struct QuickAddButton_HomeView_Popover: View {
    var buttonAction: (() -> Void)?
    var body: some View {
        PopoverContents(texts: ["Press this button any time you want to add a new item"],
                        height: 110,
                        buttonTitle: "Done",
                        buttonAction: buttonAction)
    }
}

#Preview {
    Totals_HomeView_Popover {
    }
}

#Preview {
    NetMoney_HomeView_Popover {
    }
}

#Preview {
    PayoffQueue_HomeView_Popup {
    }
}

// #Preview {
//    PopoverContents()
//
// }
