//
//  TodayViewTotalsHeaderView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/8/23.
//

import SwiftUI

// MARK: - TotalsHeader

struct TodayViewTotalsHeaderView: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    var body: some View {
        HStack {
            Text("Totals to Date")
                .font(.callout)
                .fontWeight(.semibold)
            Spacer()
            Text("More Stats")
                .format(size: 14, weight: .medium, color: .textSecondary)
                .onTapGesture {
                    vm.navigator.push(.stats)
                }
        }
    }
}



#Preview {
    TodayViewTotalsHeaderView()
        .environmentObject(NewHomeViewModel())
}
