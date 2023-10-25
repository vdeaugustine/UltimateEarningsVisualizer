//
//  TimeBlockLeaderboard.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/25/23.
//

import SwiftUI

struct TimeBlockLeaderboard: View {
    let blocks: [CondensedTimeBlock]

    var sortedBlocks: [CondensedTimeBlock] {
        blocks.sorted(by: >).prefixArray(5)
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.yellow)
                    .font(.footnote)

                Text("Top Blocks")
                    .font(.headline)

                Spacer()
            }

            VStack {
                ForEach(sortedBlocks, id: \.self) { block in
                    VStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(block.color)
                                .frame(width: 2)
                                .padding(.top, 2)

                            Text("Block")
                                .font(.subheadline)
                                .spacedOut {
                                    Text(block.duration.breakDownTime())
                                        .font(.caption2)
                                }
                        }

                        Divider()
                    }
                }
            }
            .padding(.top, 7)
            
        }
        .padding()
        .background(
            Color(.tertiarySystemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        )
    }
}

#Preview {
    ZStack {
        Color(.secondarySystemBackground)
        TimeBlockLeaderboard(blocks: User.main.getTimeBlocksBetween().consolidate())
            .frame(width: 200, height: 200.0)
    }
}
