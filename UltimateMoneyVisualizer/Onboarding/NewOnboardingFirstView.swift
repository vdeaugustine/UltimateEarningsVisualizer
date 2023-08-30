//
//  NewOnboardingFirstView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/29/23.
//

import SwiftUI
import WelcomeSheet

// MARK: - NewOnboardingFirstView

struct NewOnboardingFirstView: View {
    @State private var showSheet = false
    let pages = [WelcomeSheetPage(title: "Welcome to Welcome Sheet",
                                  rows: [WelcomeSheetPageRow(imageSystemName: "rectangle.stack.fill.badge.plus",
                                                             title: "Quick Creation",
                                                             content: "It's incredibly intuitive. Simply declare an array of pages filled with content."),
                                         WelcomeSheetPageRow(imageSystemName: "slider.horizontal.3",
                                                             title: "Highly Customisable",
                                                             content: "Match sheet's appearance to your app, link buttons, perform actions after dismissal."),
                                         WelcomeSheetPageRow(imageSystemName: "ipad.and.iphone",
                                                             title: "Works out of the box",
                                                             content: "Don't worry about various screen sizes. It will look gorgeous on every iOS device.")]),
                 WelcomeSheetPage(title: "Welcome to Welcome Sheet",
                                               rows: [WelcomeSheetPageRow(imageSystemName: "rectangle.stack.fill.badge.plus",
                                                                          title: "Quick Creation",
                                                                          content: "It's incredibly intuitive. Simply declare an array of pages filled with content."),
                                                      WelcomeSheetPageRow(imageSystemName: "slider.horizontal.3",
                                                                          title: "Highly Customisable",
                                                                          content: "Match sheet's appearance to your app, link buttons, perform actions after dismissal."),
                                                      WelcomeSheetPageRow(imageSystemName: "ipad.and.iphone",
                                                                          title: "Works out of the box",
                                                                          content: "Don't worry about various screen sizes. It will look gorgeous on every iOS device.")])]

    var body: some View {
        Button("Show sheet") {
            showSheet.toggle()
        }
        .welcomeSheet(isPresented: $showSheet, pages: pages)
    }
}

// MARK: - NewOnboardingFirstView_Previews

struct NewOnboardingFirstView_Previews: PreviewProvider {
    static var previews: some View {
        NewOnboardingFirstView()
    }
}
