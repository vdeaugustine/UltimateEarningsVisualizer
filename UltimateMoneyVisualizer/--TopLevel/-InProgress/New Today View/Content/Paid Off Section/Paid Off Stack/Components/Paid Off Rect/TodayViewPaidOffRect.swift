//
//  TodayViewPaidOffRect.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewPaidOffRect: View {
    let item: PayoffItem
    let progressAmount: Double
    @ObservedObject var viewModel: TodayViewModel

    var body: some View {
        HStack {
            progressCircle

            VStack(alignment: .leading) {
                Text(item.titleStr)
                    .font(.lato(.regular, 16))
                    .fontWeight(.black)
                
                Text(item.type.rawValue.uppercased())
                    .font(.lato(.regular, 12))
                    .fontWeight(.bold)
                    .foregroundStyle(Color(uiColor: .gray))
                
            }
            
            Spacer()
            
            VStack {
                
                Text(progressAmount.formattedForMoney().replacingOccurrences(of: "$", with: "+"))
                    .font(.lato(.regular, 16))
                    .fontWeight(.black)
                
                Text(item.amountMoneyStr)
                    .font(.lato(.regular, 12))
                    .fontWeight(.bold)
                    .foregroundStyle(Color(uiColor: .gray))
                
                
            }
            
        }
        .padding(12, 20)
        .background(.white)
        .cornerRadius(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .inset(by: 0.5)
                .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
                .foregroundStyle(Color.white)
        )
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
    
    
    var gradient: LinearGradient {
        switch item.type {
            case .goal:
                return viewModel.goalsColor.getGradient()
            case .expense:
                return viewModel.expensesColor.getGradient()
            case .tax:
                return viewModel.taxesColor.getGradient()
        }
    }

    var progressCircle: some View {
        ProgressCircle(percent: item.percentPaidOff,
                       widthHeight: 64,
                       gradient: gradient,
                       lineWidth: 5,
                       showCheckWhenComplete: false) {
            VStack(spacing: 2) {
                Text(item.amountPaidOff.formattedForMoney())
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(gradient)
            }
        }
    }
}



#Preview {
    ZStack {
        Color.targetGray
        TodayViewPaidOffRect(item: TodayViewModel.main.user.getGoals().first!,
                             progressAmount: 43.21,
                             viewModel: TodayViewModel.main)
    }
}
