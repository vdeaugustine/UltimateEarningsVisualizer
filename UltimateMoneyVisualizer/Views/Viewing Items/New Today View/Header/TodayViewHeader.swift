//
//  TodayViewHeader.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewHeader: View {
    @EnvironmentObject private var model: TodayViewModel
    
    var body: some View {
        ZStack {
            TodayViewHeaderBackground()
            TodayViewHeaderContent()
                .offset(y: model.shiftIsOver ? -10 : 0)
        }
    }
}

struct TodayViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewHeader()
            .environmentObject(TodayViewModel.main)
    }
}
