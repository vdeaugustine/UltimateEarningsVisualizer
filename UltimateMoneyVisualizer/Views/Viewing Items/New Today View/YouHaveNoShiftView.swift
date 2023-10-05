//
//  YouHaveNoShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/25/23.
//

import SwiftUI

// MARK: - YouHaveNoShiftView

struct YouHaveNoShiftView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showHoursSheet: Bool
    @ObservedObject var settings = User.main.getSettings()
    @EnvironmentObject private var model: TodayViewModel

    var body: some View {
        NoContentPlaceholderCustomView(title: "Today's Shift",
                                       subTitle: "You do not have a shift scheduled for today.",
                                       imageSystemName: "calendar.badge.clock",
                                       buttonTitle: "Add Shift",
                                       buttonColor: settings.themeColor) {
            showHoursSheet = true
            model.showHoursSheet = true
        }
    }

}

// MARK: - YouHaveNoShiftView_Previews

struct YouHaveNoShiftView_Previews: PreviewProvider {
    static var previews: some View {
        YouHaveNoShiftView(showHoursSheet: .constant(false))
    }
}
