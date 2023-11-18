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
    
    var body: some View {
        TabView(selection: $tab) {
            WageOnboarding(tab: $tab).tag(0)
            ExpenseOnboarding(tab: $tab).tag(1)
            GoalOnboarding(tab: $tab).tag(2)
            AllocationOnboarding(showOnboarding: $showOnboarding, tab: $tab).tag(3)
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
