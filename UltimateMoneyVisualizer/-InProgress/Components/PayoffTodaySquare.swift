//
//  PayoffTodaySquare.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/8/23.
//

import SwiftUI

// MARK: - PayoffTodaySquare

struct PayoffTodaySquare: View {
    @ObservedObject private var settings = User.main.getSettings()

    let title: String
    let itemTotal: Double
    let progressAmount: Double
//    let payoffItem: PayoffItem
    let havedPaidOff: Double

    var progressToShow: Double {
        progressAmount > 0 ? progressAmount : 0
    }
    
    let payoffType: PayoffType

    var percent: Double {
        havedPaidOff / itemTotal
    }

    var body: some View {
        VStack {
            HStack {
                ProgressCircle(percent: percent,
                               widthHeight: 75,
                               lineWidth: 5) {
                    
                    VStack(spacing: 2){
                        Text(havedPaidOff.formattedForMoney())
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                        Text(progressToShow.formattedForMoney(includeCents: true).replacingOccurrences(of: "$", with: "+"))
                            .font(.caption2)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            
                    }
                    .offset(y: 5)
                    .padding(.horizontal, 2)
                }

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .lineLimit(2)
                    
                   

                    HStack(alignment: .bottom, spacing: 5) {
                        
                        
                        
                        Text(itemTotal.formattedForMoney())
                            .lineLimit(1)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())

                        
                    }
                    
                    Text(payoffType.rawValue.uppercased())
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                }
//                .padding([.horizontal])
//                .pushLeft()
            }
        }
    }
}

// MARK: - PayoffTodaySquare_Previews

struct PayoffTodaySquare_Previews: PreviewProvider {
    static var item: PayoffItem {
        User.main.getQueue().first!
    }

    static var previews: some View {
        PayoffTodaySquare(title: item.titleStr, itemTotal: item.amount, progressAmount: 25, havedPaidOff: item.amount * 1, payoffType: .init(item))
            .frame(width: UIScreen.main.bounds.width / 2 - 10)
            .previewLayout(.sizeThatFits)
    }
}
