//
//  SFSymbolsPicker.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/21/23.
//

import SwiftUI
import Vin

// MARK: - SFSymbolsPicker

struct SFSymbolsPicker: View {
    @State private var selectedSymbol: String?

    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        ScrollView {
            LazyVGrid(columns: GridItem.flexibleItems(4)) {
                ForEach(sfSymbols, id: \.self) { symbol in
                    Button(action: {
                        selectedSymbol = symbol
                    }) {
                        SystemImageWithFilledBackground(systemName: symbol, backgroundColor: settings.themeColor, width: 59, height: 59)
                    }
                }
            }
            .padding()

            if let selectedSymbol {
                SystemImageWithFilledBackground(systemName: selectedSymbol, backgroundColor: settings.themeColor)
                Text(selectedSymbol)
            }
        }
    }

    let sfSymbols: [String] = ["house.fill",
                               "banknote.fill",
                               "creditcard.fill",
                               "briefcase.fill",
                               "wallet.pass.fill",
                               "chart.pie.fill",
                               "chart.bar.fill",
                               "chart.line.uptrend.xyaxis.circle.fill",
                               "percent",
                               "dollarsign.circle",
                               "dollarsign.square.fill",
                               "dollarsign.square",
                               "gift.fill",
                               "greetingcard.fill",
                               "creditcard.circle.fill",
                               "banknote",
                               "paperplane.fill",
                               "doc.text.fill",
                               "cart.badge.plus",
                               "briefcase",
                               "book.fill",
                               "signature",
                               "bag.fill",
                               "bag.circle.fill",
                               "bag.badge.plus",
                               "timer.square",
                               "tag.fill",
                               "tag.circle.fill",
                               "tag.square.fill",
                               "wrench.fill",
                               "pencil.tip",
                               "chart.pie",
                               "chart.bar",
                               "chart.line.uptrend.xyaxis",
                               "arrow.up.doc.fill",
                               "arrow.up.circle.fill",
                               "arrow.up.square.fill",
                               "arrow.up.right.circle.fill",
                               "arrow.up.right.square.fill",
                               "arrow.up.left.circle.fill",
                               "arrow.up.left.square.fill",
                               "flame.fill",
                               "bolt.fill"]
}

// MARK: - SFSymbolsPicker_Previews

struct SFSymbolsPicker_Previews: PreviewProvider {
    static var previews: some View {
        SFSymbolsPicker()
    }
}