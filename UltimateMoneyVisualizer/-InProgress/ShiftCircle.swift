//
//  ShiftCircle.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/3/23.
//

import SwiftUI

struct ShiftCircle: View {
    
    @ObservedObject private var user: User = User.main
    @ObservedObject private var wage = User.main.getWage()
    @ObservedObject private var settings = User.main.getSettings()
    
    var dateComponent: DateComponents?
    var isEditing: Bool = false
    var isSelected: Bool = false
    var dateGiven: Date? = nil

    var body: some View {
        let date = dateGiven ?? Calendar.current.date(from: dateComponent ?? .init())!
        let monthAbbreviation = date.getFormattedDate(format: "MMM")
        let day = date.getFormattedDate(format: "d")

        return ZStack {
            Circle()
                .fill(settings.getDefaultGradient())
            VStack {
                Text(monthAbbreviation)
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                Text(String(day))
                    .font(.system(size: 18, weight: .medium))
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .frame(height: 50)
        .overlay {
            if isEditing {
                GeometryReader { geo in
                    CircleBadgeView(isEditing: isEditing, isSelected: isSelected, width: geo.size.width)
                }
            }
        }
        
    }
}

// MARK: - ShiftCircle_Previews

struct ShiftCircle_Previews: PreviewProvider {
    static var previews: some View {
        ShiftCircle(dateComponent: DateComponents(calendar: .current, day: 320))
            .previewDevice("iPhone SE (3rd generation)")
            .putInNavView(.inline)
    }
}
