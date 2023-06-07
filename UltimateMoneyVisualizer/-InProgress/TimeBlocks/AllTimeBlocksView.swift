//
//  AllTimeBlocksForShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import SwiftUI

// MARK: - AllTimeBlocksView

struct AllTimeBlocksView: View {
    @ObservedObject private var user: User = .main

    func occurrencesOf(_ block: TimeBlock) -> Int {
        guard let mainBlockTitle = block.title else { return 0 }
        return user.getTimeBlocksBetween().filter {
            if let title = $0.title {
                return title == mainBlockTitle
            }
            return false
        }.count
    }

    func removeRedundant(_ blocks: [TimeBlock]) -> [TimeBlock] {
        return blocks.reduce(into: [TimeBlock]()) { result, block in
            guard let blockTitle = block.title else { return }
            if !result.contains(where: { $0.title == blockTitle }) {
                result.append(block)
            }
        }
    }
    
    func totalMadeFor(block: TimeBlock) -> Double {
        guard let mainBlockTitle = block.title else { return 0 }
        return user.getTimeBlocksBetween().filter {
            if let title = $0.title {
                return title == mainBlockTitle
            }
            return false
        }.reduce(Double.zero, { $0 + $1.amountEarned() })
    }

    var body: some View {
        List {
            ForEach(removeRedundant(user.getTimeBlocksBetween())) { block in
                VStack {
                    HStack {
                        if let title = block.title {
                            Text(title)
                        }
                        Spacer()
                        VStack {
                            Text(occurrencesOf(block).str + " times")
                            Text(totalMadeFor(block: block).formattedForMoney())
                        }
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Time Blocks")
    }
}

// MARK: - AllTimeBlocksView_Previews

struct AllTimeBlocksView_Previews: PreviewProvider {
    static var previews: some View {
        AllTimeBlocksView()
            .putInNavView(.inline)
    }
}
