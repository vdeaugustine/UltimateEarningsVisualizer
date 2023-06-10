//
//  EditTimeBlockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/8/23.
//

import SwiftUI

struct EditTimeBlockView: View {
    
    @State private var startTime: Date
    @State private var endTime: Date
    
    init(block: TimeBlock) {
        self._startTime = State(initialValue: block.startTime ?? .nineAM)
        self._endTime = State(initialValue: block.endTime ?? .fivePM)
        self.block = block
    }
    
    
    let block: TimeBlock
    
    var body: some View {
        Form {
            DatePicker("Block Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
            DatePicker("Block End Time", selection: $endTime, displayedComponents: .hourAndMinute)
        }
    }
}


struct EditTimeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        EditTimeBlockView(block: User.main.getTimeBlocksBetween().first!)
    }
}

