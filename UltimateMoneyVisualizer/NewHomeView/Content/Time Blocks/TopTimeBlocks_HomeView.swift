//
//  TopTimeBlocks_HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/25/23.
//

import SwiftUI

// MARK: - TopTimeBlocks_HomeView

struct TopTimeBlocks_HomeView: View {
    @EnvironmentObject private var vm: NewHomeViewModel
    var consolidatedBlocks: [CondensedTimeBlock] {
        vm.user.getTimeBlocksBetween().consolidate()
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Top Time Blocks")
                    .font(.callout)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    vm.navigator.push(.allTimeBlocks)
                } label: {
                    Text("All")
                        .format(size: 14, weight: .medium)
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if consolidatedBlocks.isEmpty {
                        TodayViewExampleItemizedBlock()
                    } else {
                        ForEach(consolidatedBlocks) { block in

                            TimeBlockRect(title: block.title,
                                          subtitle: block.duration.breakDownTime(),
                                          thirdTitle: "",
                                          color: block.color)
                                .onTapGesture {
                                    vm.navigator.push(.condensedTimeBlock(block))
                                }
                        }
                    }
                }
                .padding()
            }
        }

        .background { Color.clear }
    }
}

#Preview {
    TopTimeBlocks_HomeView()
        .environmentObject(NewHomeViewModel())
}
