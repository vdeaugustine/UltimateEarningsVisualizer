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

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 124)
                .frame(maxWidth: 181)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 1, y: 3)

            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: imageName)
                    .font(.system(size: 28))

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
