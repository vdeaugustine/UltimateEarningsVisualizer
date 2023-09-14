//
//  YouHaveNoShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/25/23.
//

import SwiftUI

// MARK: - YouHaveNoShiftView

// Views like TimeMoneyPicker, SelectHours, ProgressSectionView,
// TodaysSpendingView, StartEndTotalView, YouHaveNoShiftView will remain same as I have mentioned in previous responses.

struct YouHaveNoShiftView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showHoursSheet: Bool
    @ObservedObject var settings = User.main.getSettings()
    @EnvironmentObject private var model: TodayViewModel
    

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "calendar.badge.clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 85)
                .foregroundColor(.gray)

            VStack(spacing: 14) {
                Text("Today's Shift")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text("You do not have a shift scheduled for today.")
                    .fontWeight(.medium)
            }

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, content: {
            Button {
                showHoursSheet = true
                model.showHoursSheet = true
                print(model.spentOnGoals.str)
            } label: {
                ZStack {
                    Capsule()
                        .fill(settings.getDefaultGradient())
                    Text("Add Shift")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .frame(width: 135, height: 50)
            }

        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

struct YouHaveNoShiftView_Previews: PreviewProvider {
    static var previews: some View {
        YouHaveNoShiftView(showHoursSheet: .constant(false))
    }
}