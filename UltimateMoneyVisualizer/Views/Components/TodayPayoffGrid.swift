//
//  TodayPayoffGrid.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/8/23.
//

import Charts
import SwiftUI

// MARK: - TodayPayoffGrid

struct TodayPayoffGrid: View {
    @ObservedObject private var user: User = .main

    @ObservedObject var viewModel: TodayViewModel

    var body: some View {
        LazyVGrid(columns: GridItem.flexibleItems(2)) {
            ForEach(viewModel.tempPayoffs) { item in
                if item.progressAmount > 0.01 {
                    PayoffTodaySquare(item: item)
                        .pushLeft()
                }
            }
        }
    }
}

// MARK: - TodayPayoffGrid_Previews

struct TodayPayoffGrid_Previews: PreviewProvider {
    static var previews: some View {
        TodayPayoffGrid(viewModel: .init())
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
