//
//  AllTimeBlocksForShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import Charts
import SwiftPieChart
import SwiftUI
import Vin

// MARK: - AllTimeBlocksView

struct AllTimeBlocksView: View {
    @ObservedObject private var user: User = .main
    @State private var selectedBlock: TimeBlock? = nil

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
                    .foregroundStyle(isSelected(block) ? Color.white : Color.black)
                    .allPartsTappable(alignment: .leading)
                    .onTapGesture {
                        if isSelected(block) {
                            selectedBlock = nil
                        } else {
                            selectedBlock = block
                        }
                    }
                }

                .conditionalModifier(isSelected(block)) {
                    $0
                        .listRowBackground(
                            user.getSettings().getDefaultGradient()
                        )
                }
            }

            Section {
                Chart {
                    ForEach(removeRedundant(user.getTimeBlocksBetween())) { block in

                        if let blockTitle = block.title {
                            BarMark(x: .value("Earned", totalMadeFor(block: block)),
                                    y: .value("Title", blockTitle))
                            
                            .annotation(position: .overlay) {
                                Text(totalMadeFor(block: block).formattedForMoney())
                                    .font(.caption2)
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                }
                
                .chartXAxis(.hidden)
                .chartLegend(.visible)
                .padding()
                .frame(minHeight: 250)
            }
        }
        .putInTemplate()
        .navigationTitle("Time Blocks")
    }
}

extension AllTimeBlocksView {
    func isSelected(_ block: TimeBlock) -> Bool {
        if let selectedBlockTitle = selectedBlock?.title,
           let thisBlockTitle = block.title,
           thisBlockTitle == selectedBlockTitle {
            return true
        }
        return false
    }

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
        }.reduce(Double.zero) { $0 + $1.amountEarned() }
    }
}

// MARK: - AllTimeBlocksView_Previews

struct AllTimeBlocksView_Previews: PreviewProvider {
    static var previews: some View {
        AllTimeBlocksView()
            .putInNavView(.inline)
    }
}
