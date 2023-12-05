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
    @Binding var selectedSymbol: String

    @ObservedObject private var settings = User.main.getSettings()

    var numberOfColumns: Int = 4
    var width: CGFloat = 50
    var height: CGFloat = 50
    var color: Color = User.main.getSettings().themeColor
    @State private var showSymbolName = false
    @State private var symbolNameToShow = ""
    
    var completion: (() -> Void)? = nil
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: GridItem.flexibleItems(numberOfColumns)) {
                ForEach(sfSymbols, id: \.self) { symbol in
                    Button(action: {
                        selectedSymbol = symbol
                        completion?()
                        #if DEBUG
                        print(symbol)
                        #endif
                    }) {
                        SystemImageWithFilledBackground(systemName: symbol, backgroundColor: color, width: width, height: height)
                    }
                }
            }
        }
        .alert(symbolNameToShow, isPresented: $showSymbolName, actions: {})
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
                               "wrench.fill",
                               "pencil.tip",
                               "chart.pie",
                               "chart.bar",
                               "chart.line.uptrend.xyaxis",
                               "flame.fill",
                               "bolt.fill",
                               "car.fill",
                               "bicycle",
                               "airplane",
                               "tram.fill",
                               "bus.fill",
                               "cablecar.fill",
                               "arrow.up.right.diamond.fill",
                               "film",
                               "video.fill",
                               "camera.fill",
                               "mic.fill",
                               "headphones",
                               "music.note",
                               "tv.fill",
                               "desktopcomputer",
                               "printer.fill",
                               "keyboard",
                               "computermouse.fill",
                               "phone.fill",
                               "faxmachine",
                               "envelope.fill",
                               "pencil",
                               "paintbrush.fill",
                               "ruler.fill",
                               "safari",
                               "gear",
                               "globe",
                               "book",
                               "book.closed",
                               "graduationcap.fill",
                               "text.book.closed.fill",
                               "pencil.and.ellipsis.rectangle",
                               "paintpalette.fill",
                               "ticket.fill",
                               "puzzlepiece.fill",
                               "gamecontroller.fill",
                               "die.face.5.fill",
                               "map.fill",
                               "globe.americas.fill",
                               "mappin.and.ellipse",
                               "umbrella.fill",
                               "bolt",
                               "moon.fill",
                               "sun.max.fill",
                               "cloud.fill",
                               "cloud.rain.fill",
                               "cloud.snow.fill",
                               "tornado",
                               "thermometer",
                               "umbrella",
                               "bed.double.fill",
                               "building.fill",
                               "building.2.fill",
                               "house",
                               "person.fill",
                               "person.2.fill",
                               "pawprint.fill",
                               "stethoscope",
                               "bandage.fill",
                               "pills.fill",
                               "cross.fill",
                               "eyedropper",
                               "scalemass.fill",
                               "leaf.fill",
                               "trash.fill",
                               "trash.circle.fill",
                               "tuningfork",
                               "hammer.fill",
                               "eyedropper.halffull",
                               "drop.fill",
                               "paintbrush",
                               "wrench",
                               "screwdriver.fill",
                               "scissors",
                               "slider.horizontal.below.rectangle",
                               "lightbulb.fill",
                               "lightbulb",
                               "lifepreserver.fill",
                               "shippingbox.fill",
                               "exclamationmark.triangle.fill",
                               "questionmark.diamond.fill",
                               "alarm.fill",
                               "clock.fill",
                               "stopwatch.fill",
                               "timer",
                               "applewatch",
                               "hourglass",
                               "shield.fill",
                               "lock.fill",
                               "key.fill",
                               "gift",
                               "hand.thumbsup.fill",
                               "star.fill",
                               "sparkles",
                               "rosette"]
}

// MARK: - SFSymbolsPicker_Previews

struct SFSymbolsPicker_Previews: PreviewProvider {
    static var previews: some View {
        SFSymbolsPicker(selectedSymbol: .constant(""), width: 60, height: 60)
    }
}
