//
//  YouHaveCompletedYourShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/11/23.
//

import SwiftUI

struct YouHaveCompletedYourShiftView: View {
    @Environment(\.managedObjectContext) private var viewContext
        @Binding var showHoursSheet: Bool
        @ObservedObject var settings = User.main.getSettings()
        @EnvironmentObject private var model: TodayViewModel

        var body: some View {
            NoContentPlaceholderCustomView(title: "Today's Shift",
                                           subTitle: "Your shift for today has already been completed.",
                                           imageSystemName: "calendar.badge.checkmark",
                                           buttonTitle: "View Details",
                                           buttonColor: settings.themeColor) {
                // Add action for the button here
            }
            .background(Color(.secondarySystemBackground))
        }
}

#Preview {
    YouHaveCompletedYourShiftView(showHoursSheet: .constant(false))
        .environmentObject(TodayViewModel(context: PersistenceController.testing))
        .environment(\.managedObjectContext, PersistenceController.testing)
}
