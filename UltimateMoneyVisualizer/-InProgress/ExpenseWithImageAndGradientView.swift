//
//  ExpenseWithImageAndGradientView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/30/23.
//

import SwiftUI
import Vin



// MARK: - GradientOverlayView

struct ExpenseWithImageAndGradientView: View {
    let expense: Expense
    var maxHeight: CGFloat = 150
    
    var moneyString: String {
        let completed: String = expense.amountPaidOff.formattedForMoney()
        let total: String = expense.amountMoneyStr
        //            .replacingOccurrences(of: "$", with: "")
        
        return completed + " / " + total
        
    }
    
    
    var body: some View {
        ZStack {
            if let image = Image(expense.loadImageIfPresent()) {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                //                Color.hexStringToColor(hex: "86A57A")
                Image.defaultImage()
                
                    .resizable()
                
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
            }
        }
        
        .overlay(
            ZStack {
                LinearGradient(gradient: Gradient(stops: [.init(color: Color.black.opacity(0.7), location: 0.1),
                                                          .init(color: Color.black.opacity(0.5), location: 0.25),
                                                          .init(color: Color.black.opacity(0.1), location: 1)]),
                               startPoint: .bottom,
                               endPoint: .top)
                
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(alignment: .bottom) {
                                Text(expense.titleStr)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                                Spacer()
                                Text(moneyString)
                                    .font(.caption2)
                            }
                            
                            ProgressBar(percentage: expense.percentPaidOff, height: 3)
                            
                            HStack {
                                Text(expense.dueDate?.getFormattedDate(format: .abreviatedMonth) ?? "")
                                
                                Spacer()
                                Text( (expense.percentPaidOff * 100).simpleStr() + "%")
                            }
                            .font(.caption2)
                        }
                        .foregroundColor(Color.white)
                        Spacer()
                    }
                }
                .padding(4)
            }
        )
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
        .cornerRadius(8)
        
    }
}

// MARK: - GradientOverlayView_Previews

struct ExpenseWithImageAndGradientView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseWithImageAndGradientView(expense: User.main.getExpenses().first!)
        
//        ZStack {
//
//            HStack(spacing: 0) {
//                Color.hexStringToColor(hex: "302E5B")
//                Color.hexStringToColor(hex: "8B68B0")
//            }
//
//            Image("creditCard")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding()
//
//        }
        
        
        
    }
}

