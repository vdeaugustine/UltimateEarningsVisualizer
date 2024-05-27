//
//  PayoffItemDetailTotalAmount.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/12/23.
//

import SwiftUI

// MARK: - PayoffItemDetailTotalAmount

struct PayoffItemDetailTotalAmount: View {
    @ObservedObject var viewModel: PayoffItemDetailViewModel
    @State private var showRepeatSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.payoffItem.amount.money())
                    .font(.title)
                    .boldNumber()

                Spacer()
                
                Components.nextPageChevron
            }
            .layoutPriority(0)
            VStack(alignment: .leading, spacing: 7) {
                Text("Repeats")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxHeight: .infinity)
                    .layoutPriority(2)
                    .minimumScaleFactor(0.4)

                HStack {
                    Text(viewModel.payoffItem.repeatFrequencyObject.rawValue)
                    Spacer()
                }
                .font(.subheadline)
                .foregroundStyle(Color.gray)
                .layoutPriority(1)
                .minimumScaleFactor(0.85)
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
        .frame(height: 120)
        .onTapGesture {
            showRepeatSheet.toggle()
        }
        .sheet(isPresented: $showRepeatSheet, content: {
            if let expense = viewModel.payoffItem as? Expense {
                PayoffItemRepeatView(payoffItem: expense)
            }
           
        })
    }
}

// MARK: - PayoffItemDetailTotalAmount_Previews

struct PayoffItemDetailTotalAmount_Previews: PreviewProvider {
    
    static var previews: some View {
        
        
        ZStack {
            Color.secondarySystemBackground
            PayoffItemDetailTotalAmount(viewModel: PayoffItemDetailViewModel(payoffItem: User.main.getGoals()
                    .sorted(by: { $0.timeRemaining > $1.timeRemaining })
                    .last!))
        }
        .ignoresSafeArea()
    }
}
