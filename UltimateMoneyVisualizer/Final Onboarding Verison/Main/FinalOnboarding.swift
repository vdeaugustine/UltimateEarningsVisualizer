//
//  GetStartedEnterWage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/13/23.
//

import SwiftUI
import Vin

struct FinalOnboarding: View {
    @State private var tab: Int = 0
    @ObservedObject var user: User = .main
    @Binding var showOnboarding: Bool
    let totalSlides = 5

    var body: some View {
        TabView(selection: $tab) {
            WelcomeOnboarding(tab: $tab, totalSlides: totalSlides).tag(0)
            WageOnboarding(tab: $tab, totalSlides: totalSlides).tag(1)
            ExpenseOnboarding(tab: $tab, totalSlides: totalSlides).tag(2)
            GoalOnboarding(tab: $tab, totalSlides: totalSlides).tag(3)
            AllocationOnboarding(showOnboarding: $showOnboarding,
                                 totalSlides: totalSlides, tab: $tab).tag(4)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea(.container, edges: .top)
        .onChangeProper(of: tab) {
            #if !DEBUG
                if user.wage == nil {
                    tab = 0
                }
            #endif
        }
        .environmentObject(user)
    }
}

#Preview {
    FinalOnboarding(user: .testing, showOnboarding: .constant(true))
//        .onAppear(perform: {
//            if let wage = User.testing.wage {
//                User.testing.getContext().delete(wage)
//                try! User.testing.getContext().save()
//            }
//        })
}
