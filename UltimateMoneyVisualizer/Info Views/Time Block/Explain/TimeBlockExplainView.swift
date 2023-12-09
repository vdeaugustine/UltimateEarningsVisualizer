//
//  TimeBlockExplainView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/23/23.
//

import SwiftUI

// MARK: - TimeBlockExplainView

struct TimeBlockExplainView: View {
    var body: some View {
        List {
            NavigationLink {
                WhatAreTimeBlocks()
            } label: {
                Text("What are they")
            }
            NavigationLink {} label: {
                Text("What are the benefits")
            }
            NavigationLink {} label: {
                Text("How to use them")
            }
        }
        
    }
}

// MARK: - WhatAreTimeBlocks

struct WhatAreTimeBlocks: View {
    static let today: TodayShift = {
        let shift = TodayShift(context: PersistenceController.testing)
        shift.startTime = .nineAM
        shift.endTime = .fivePM
        
        let timeBlock = TimeBlock(context: PersistenceController.testing)
        timeBlock.startTime = .getThisTime(hour: 10, minute: 15)
        timeBlock.endTime = .getThisTime(hour: 13, minute: 45)
        timeBlock.title = "Reviewed Money Visualizer"
        timeBlock.colorHex = Color.blue.getHex()
        shift.addToTimeBlocks(timeBlock)
        return shift
    }()
    var body: some View {
        VStack {
            
            GroupBox("Condensed View") {
                TodayViewExampleItemizedBlock()
            }
            
            GroupBox("Expanded") {
                TodayViewTimeBlocksExpanded(shift: WhatAreTimeBlocks.today)
                    
            }
        }
    }
}

#Preview {
    TimeBlockExplainView()
        .putInNavView(.automatic)
}
