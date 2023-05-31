//
//  GoalsGridView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/29/23.
//

import SwiftUI
import Vin

// MARK: - GoalsGridView

struct GoalsGridView: View {
    @ObservedObject private var user = User.main

    var body: some View {
        ScrollView {
            LazyVGrid(columns: GridItem.fixedItems(2, size: 180),
                      alignment: .center) {
                ForEach(user.getGoals()) { goal in
                    GradientOverlayView(goal: goal, maxHeight: 180)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .padding()
        .background {
            Color.listBackgroundColor
        }
        .putInTemplate()
        .navigationTitle("Goals")
    }
}

// MARK: - GoalsGridView_Previews

struct GoalsGridView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsGridView()
            .putInNavView(.inline)
    }
}
