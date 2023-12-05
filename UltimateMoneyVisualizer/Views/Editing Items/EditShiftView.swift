//
//  EditTimeBlockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/17/23.
//

import SwiftUI

struct EditShiftView: View {
    // MARK: - Properties

    init(shift: Shift) {
        self.shift = shift
        _start = State(initialValue: shift.getStart())
        _end = State(initialValue: shift.getEnd())
    }

    let shift: Shift

    @State private var start: Date
    @State private var end: Date
    var body: some View {
        Form {
            Section("Times") {
                DatePicker("Start Time", selection: $start, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $end, displayedComponents: .hourAndMinute)
            }

            Section("Time Blocks") {
                ItemizedPartOfShiftView(shift: shift)
//                    NewTimeBlocksForShiftView(shift: shift)
                    .padding(.vertical)
            }
        }
        .putInTemplate(title: "Edit shift")
        .toolbarSave {
        }
    }

    // MARK: - Sub Views

    // MARK: - Computed properties

    // MARK: - Helper functions
}

struct ViewNameEditShiftView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditShiftView(shift: User.main.getShifts().first!)
                .environmentObject(NavManager.shared)
                .navigationDestination(for: NavManager.AllViews.self) { view in
                    NavManager.shared.getDestinationViewForStack(destination: view)
                }
        }
    }
}
