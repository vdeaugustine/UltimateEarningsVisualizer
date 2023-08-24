//
//  PayoffItemDetailProgressBox.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import SwiftUI
import Vin

// MARK: - PayoffItemDetailProgressBox

struct PayoffItemDetailProgressBox: View {
    @ObservedObject var viewModel: PayoffItemDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Progress")
                        .fontWeight(.semibold)
                    Text([viewModel.payoffItem.getAllocations().count.str,
                          "contributions"])
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }

            VStack (alignment: .leading, spacing: 35) {
                HStack {
                    batteryImage

                    VStack(alignment: .center) {
                        Text(viewModel.payoffItem.amountPaidOff.moneyExtended(decimalPlaces: 2))
                            .fontWeight(.semibold)
                            .font(.title2)
                            .minimumScaleFactor(0.90)
                            
                        Divider()
                        HStack(alignment: .bottom) {
                            Text([(viewModel.payoffItem.percentPaidOff * 100).simpleStr(), "%"])
                                .fontWeight(.semibold)
                                .layoutPriority(1)
                                
                                
                                
                        }
                        .padding(.top, 5)
                    }
                }
                
                Text(viewModel.payoffItem.amountRemainingToPayOff.money() + " remaining")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
        .frame(minWidth: 175)
        .frame(minHeight: 225, maxHeight: .infinity)
    }

    var batteryImage: some View {
        VStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "E7E7E7"))
                .frame(width: 35, height: 7)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "E7E7E7"))
                    .frame(width: 50, height: 75)

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "389975"))
                    .frame(width: 50, height: 75 * viewModel.payoffItem.percentPaidOff)
            }
        }
    }
}

// MARK: - PayoffItemDetailProgressBox_Previews

struct PayoffItemDetailProgressBox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.listBackgroundColor
            PayoffItemDetailProgressBox(viewModel: PayoffItemDetailViewModel(payoffItem: User.main.getGoals().first!))
                
        }
        .ignoresSafeArea()
    }
}
