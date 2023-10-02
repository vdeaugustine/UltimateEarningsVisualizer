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
            print(model.spentOnGoals.str)
        }
    }

//    var body: some View {
//        VStack {
//            Spacer()
//
//            Image(systemName: "calendar.badge.clock")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 85)
//                .foregroundColor(.gray)
//
//            VStack(spacing: 14) {
//                Text("Today's Shift")
//                    .font(.largeTitle)
//                    .fontWeight(.semibold)
//
//                Text("You do not have a shift scheduled for today.")
//                    .fontWeight(.medium)
//                    .foregroundStyle(Color(uiColor: .secondaryLabel))
//            }
//
//            Spacer()
//        }
//        .frame(maxHeight: .infinity)
//        .safeAreaInset(edge: .bottom, content: {
//            Button {
//                showHoursSheet = true
//                model.showHoursSheet = true
//                print(model.spentOnGoals.str)
//            } label: {
//                ZStack {
//                    Capsule()
//                        .fill(settings.getDefaultGradient())
//                    Text("Add Shift")
//                        .fontWeight(.medium)
//                        .foregroundColor(.white)
//                }
//                .frame(width: 135, height: 50)
//            }
//
//        })
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.clear)
//    }
}

// MARK: - YouHaveNoShiftView_Previews

struct YouHaveNoShiftView_Previews: PreviewProvider {
    static var previews: some View {
        YouHaveNoShiftView(showHoursSheet: .constant(false))
    }
}
