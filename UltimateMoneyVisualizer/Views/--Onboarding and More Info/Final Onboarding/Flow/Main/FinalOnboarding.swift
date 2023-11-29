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
    @StateObject private var vm: FinalOnboardingModel = .shared

    typealias Page = FinalOnboardingModel.Page
    
    var body: some View {
        TabView(selection: $vm.currentPage) {
            FinalOnboardingWelcome().tag(Page.welcome)
            FinalOnboardingWage().tag(Page.wage)
            
            
  
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea(.all, edges: .vertical)
        .onChangeProper(of: tab) {
            #if !DEBUG
                if user.wage == nil {
                    tab = 0
                }
            #endif
        }
        .environmentObject(user)
        .environmentObject(vm)
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
