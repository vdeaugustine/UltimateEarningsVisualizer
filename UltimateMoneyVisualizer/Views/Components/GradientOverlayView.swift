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
    
    static func defaultImage() -> Image {
        let imageStrings = [
            "dollar3d",
//            "creditCard"
        ]
        guard let chosenString = imageStrings.randomElement()
        else {
            return Image("dollar3d")
        }
        return Image(chosenString)
    }
}

// MARK: - GradientOverlayView

struct GradientOverlayView: View {
    let goal: Goal
    var maxHeight: CGFloat = 150
    
    var moneyString: String {
        let completed: String = goal.amountPaidOff.formattedForMoney()
        let total: String = goal.amountMoneyStr
        //            .replacingOccurrences(of: "$", with: "")
        
        return completed + " / " + total
        
    }
    
    
    var body: some View {
        ZStack {
            if let image = Image(goal.loadImageIfPresent()) {
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
                                Text(goal.titleStr)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Text(moneyString)
                                    .font(.caption2)
                            }
                            
                            ProgressBar(percentage: goal.percentPaidOff, height: 3)
                            
                            HStack {
                                Text(goal.dueDate?.getFormattedDate(format: .abreviatedMonth) ?? "")
                                
                                Spacer()
                                Text( (goal.percentPaidOff * 100).simpleStr() + "%")
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
        
    }
}

// MARK: - GradientOverlayView_Previews

struct GradientOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        //        GradientOverlayView(goal: User.main.getGoals().first(where: {$0.titleStr == "New car fund"})!)
        
        ZStack {
            
            HStack(spacing: 0) {
                Color.hexStringToColor(hex: "302E5B")
                Color.hexStringToColor(hex: "8B68B0")
            }
            
            Image("creditCard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
        }
        
        
        
    }
}
