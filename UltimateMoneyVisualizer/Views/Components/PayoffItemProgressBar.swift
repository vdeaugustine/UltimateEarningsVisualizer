//
//  PayoffItemProgressBar.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import SwiftUI

// MARK: - PayoffItemProgressBar

struct PayoffItemProgressBar: View {
    let item: PayoffItem
    
    let shiftColor: Color
    
    let savedColor: Color
    
    let showLegend: Bool
    
    init(item: PayoffItem, shiftColor: Color = User.main.getSettings().themeColor, savedColor: Color = .niceRed, showLegend: Bool = false) {
        self.item = item
        self.shiftColor = shiftColor
        self.savedColor = savedColor
        self.showLegend = showLegend
    }

    var amountBySaved: Double {
        let allocs = item.getAllocations()
        let savedAllocs = allocs.filter { $0.savedItem != nil }

        return savedAllocs.reduce(Double.zero) { $0 + $1.amount }
    }

    var amountByShift: Double {
        let allocs = item.getAllocations()
        let shiftAllocs = allocs.filter { $0.shift != nil }

        return shiftAllocs.reduce(Double.zero) { $0 + $1.amount }
    }

    var percentPaid: Double {
        let amountPaid = amountBySaved + amountByShift
        return amountPaid / item.amount
    }

    var paidBySavedPercent: Double {
        
        amountBySaved / item.amount
    }

    var paidByShiftPercent: Double {
        amountByShift / item.amount
    }

    var remainingPercent: Double {
        1 - paidBySavedPercent - paidByShiftPercent
    }
    
    

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(spacing: 0) {
                    savedColor.getGradient()
                        .frame(width: paidBySavedPercent * geo.size.width)

                    shiftColor.getGradient()
                        .frame(width: paidByShiftPercent * geo.size.width)

                    Color.targetGray
                        .frame(width: remainingPercent * geo.size.width)
                }
                .cornerRadius(2)
                
                if showLegend {
                    HStack {
                        HStack {
                            Text("Shifts")
                                .font(.system(size: 12))
                            Circle()
                                .frame(height: 10)
                                .foregroundStyle(shiftColor.getGradient())
                        }
                        
                        HStack {
                            Text("Saved")
                                .font(.system(size: 12))
                            Circle()
                                .frame(height: 10)
                                .foregroundStyle(savedColor.getGradient())
                        }
                    }
                    .pushLeft()
                    .padding([.leading, .top], 3)
                }
            }
            
        }
    }
}

// MARK: - PayoffItemProgressBar_Previews

struct PayoffItemProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        PayoffItemProgressBar(item: User.main.getQueue().last!)
            .frame(height: 35)
            .padding(.horizontal)
            .preferredColorScheme(.dark)
    }
}
