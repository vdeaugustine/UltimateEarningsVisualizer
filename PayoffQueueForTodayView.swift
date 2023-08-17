//
//  PayoffQueueForTodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/16/23.
//

import SwiftUI

struct PayoffQueueForTodayView: View {
    @ObservedObject var vm: TodayViewModel = .main

    @Environment(\.editMode) private var editMode

    @State private var queue: [TempTodayPayoff] = TodayViewModel.main.tempPayoffs

    var body: some View {
        List {
            ForEach(queue) { item in
                TodayViewPaidOffRect(item: item)
                    .environmentObject(vm)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.grouped)
        .background {
            Color.listBackgroundColor
        }
        .navigationTitle("Payoff Item Queue")
        .toolbar {
            ToolbarItem {
                EditButton()
            }
        }

        .putInTemplate()
    }
}

#Preview {
    PayoffQueueForTodayView(vm: TodayViewModel.main)
        .templateForPreview()
        .environmentObject(TodayViewModel.main)
}
