//
//  GradientOverlayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/19/23.
//

import SwiftUI
import Vin

extension Image {
    init?(_ optionalImage: UIImage?) {
        guard let optionalImage else { return nil }
        self.init(uiImage: optionalImage)
    }
    
    static func defaultImage(payoffItem: PayoffItem) -> Image {
//        let imageStrings = [
//            "dollar3d",
//            "creditCard"
//        ]
        
        if payoffItem is Goal {
            return Image("dollar3d")
        }
        else {
            return Image("creditCard")
        }
        
//        guard let chosenString = imageStrings.randomElement()
//        else {
//            return Image("dollar3d")
//        }
//        return Image(chosenString)
    }
}

// MARK: - GradientOverlayView

struct PayoffWithImageAndGradientView: View {
    let item: PayoffItem
    var maxHeight: CGFloat = 150
    
    var moneyString: String {
        let completed: String = item.amountPaidOff.money()
        let total: String = item.amountMoneyStr
        
        return completed + " / " + total
        
    }
    
    
    var body: some View {
        ZStack {
            if let image = Image(item.loadImageIfPresent()) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFit()
            } else {
                //                Color.hexStringToColor(hex: "86A57A")
                Image.defaultImage(payoffItem: item)
                
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFill()
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
                                Text(item.titleStr)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                                Spacer()
                                Text(moneyString)
                                    .font(.caption2)
                            }
                            
                            ProgressBar(percentage: item.percentPaidOff, height: 3)
                            
                            HStack {
                                Text(item.dueDate?.getFormattedDate(format: .abreviatedMonth) ?? "")
                                
                                Spacer()
                                Text( (item.percentPaidOff * 100).simpleStr() + "%")
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

struct GoalWithImageAndGradientView_Previews: PreviewProvider {
    static var previews: some View {
//        PayoffWithImageAndGradientView(item: User.main.getGoals().first(where: {$0.titleStr == "New car fund"})!)
        
        PayoffWithImageAndGradientView(item: User.main.getGoals().first!)
        
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
