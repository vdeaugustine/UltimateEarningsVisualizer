//
//  TodayPaidOffStackWithHeader.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayPaidOffStackWithHeader: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("PAID OFF TODAY")
                    .font(.lato(16))
                    .fontWeight(.semibold)
                    .tracking(1)
                    .foregroundStyle(Color(hex: "4E4E4E"))
                
                Spacer()
                
                Text("Queue")
                    .font(.lato(16))
                    .fontWeight(.semibold)
                    .tracking(1)
                    .foregroundStyle(Color(hex: "4E4E4E"))
            }
            
            TodayPaidOffStack()
        }
    }
}

#Preview {
    TodayPaidOffStackWithHeader()
        .environmentObject(TodayViewModel.main)
}
