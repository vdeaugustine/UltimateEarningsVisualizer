//
//  DateCircle.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/10/23.
//

import SwiftUI

// MARK: - DateCircle

struct DateCircle: View {
    @ObservedObject private var settings = User.main.getSettings()

    let dateComponent: DateComponents?
    let height: CGFloat
    let date: Date
    let monthAbbreviation: String
    let day: String

    init(date: Date, dateComponent: DateComponents? = nil, height: CGFloat = 20) {
        self.settings = User.main.getSettings()
        self.dateComponent = dateComponent
        self.height = height
        self.date = date
        self.monthAbbreviation = date.getFormattedDate(format: "MMM")
        self.day = date.getFormattedDate(format: "d")
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(settings.getDefaultGradient())
            VStack {
                Text(monthAbbreviation)
                    .foregroundColor(.white)
                    .font(.system(size: height / 5))
                Text(String(day))
                    .font(.system(size: (18 / 50) * height, weight: .medium))
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .frame(height: height)
    }
}

struct DateCircle_Previews: PreviewProvider {
    static var previews: some View {
        DateCircle(date: .now, height: 200)
            
    }
}
