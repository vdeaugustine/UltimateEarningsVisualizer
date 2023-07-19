//
//  NewTodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct NewTodayView: View {
    @ObservedObject var viewModel: TodayViewModel = .main
    var body: some View {
        ScrollView {
            VStack {
                headerAndBar
            }
        }
        .ignoresSafeArea()
        .background(
            Color.targetGray
//            Color(hex: "FAFAFA")
        )
    }
    
    var headerAndBar: some View {
        VStack(spacing: -30) {
            TodayViewHeader()
            TodayProgressBar(viewModel: viewModel)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    NewTodayView()
}
