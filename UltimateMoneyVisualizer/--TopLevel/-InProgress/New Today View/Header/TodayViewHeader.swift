//
//  TodayViewHeader.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewHeader: View {
    var body: some View {
        ZStack {
            TodayViewHeaderBackground()
            TodayViewHeaderContent()
        }
    }
}

struct TodayViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewHeader()
            .environmentObject(TodayViewModel.main)
    }
}
