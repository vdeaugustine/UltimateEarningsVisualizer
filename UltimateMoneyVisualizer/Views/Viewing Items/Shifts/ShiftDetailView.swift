//
//  ShiftDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI
import Vin

struct ShiftDetailView: View {
    var shift: Shift
    
    var startTimeStr: String {
        shift.startDate?.getFormattedDate(format: .abreviatedMonthAndMinimalTime) ?? ""
    }
    var endTimeStr: String {
        shift.endDate?.getFormattedDate(format: .abreviatedMonthAndMinimalTime) ?? ""
    }
    var body: some View {
        VStack {
            Text("\(shift.dayOfWeek ?? "")")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Start time: \(startTimeStr)")
            Text("End time: \(endTimeStr)")
        }
        .navigationTitle("Shift Detail")
    }
}

struct ShiftDetailView_Previews: PreviewProvider {
    static let context = PersistenceController.context

    static let shift: Shift = {
        let shift = Shift(context: context)
        shift.dayOfWeek = "Monday"
        shift.startDate = Date()
        shift.endDate = Date().addingTimeInterval(8*60*60)
        return shift
    }()

    static var previews: some View {
        ShiftDetailView(shift: shift)
            .putInNavView(.large)
    }
}

