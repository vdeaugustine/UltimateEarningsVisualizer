//
//  TodayViewInfoRect.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewInfoRect: View {
    let imageName: String
    let valueString: String
    let bottomLabel: String
    
    let isPayOffItem: Bool
    let circleColor: Color

    init(imageName: String, valueString: String, bottomLabel: String) {
        self.imageName = imageName
        self.valueString = valueString
        self.bottomLabel = bottomLabel
        isPayOffItem = false
        circleColor = .white
    }

    init(circleColor: Color, valueString: String, bottomLabel: String) {
        self.valueString = valueString
        self.bottomLabel = bottomLabel
        self.imageName = ""
        
        isPayOffItem = true
        self.circleColor = circleColor
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 124)
                .frame(maxWidth: 181)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 1, y: 3)

            VStack(alignment: .leading, spacing: 12) {
                if isPayOffItem {
                    Circle()
                        .fill(circleColor)
                        .frame(height: 20)
                        
                } else {
                    Image(systemName: imageName)
                        .font(.system(size: 28))
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(valueString)
                        .font(.lato(.bold, 24))
                    Text(bottomLabel)
                        .font(.lato(.regular, 18))
                        .foregroundStyle(Color(hex: "868686"))
                }
            }
            .padding(.leading, 16)
        }
    }
}

#Preview {
    ZStack {
        Color.targetGray
        TodayViewInfoRect(imageName: "hourglass",
                          valueString: "08:14:32",
                          bottomLabel: "Remaining")
    }
    .environmentObject(TodayViewModel.main)
}
