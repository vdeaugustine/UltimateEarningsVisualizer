//
//  SettingsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    private var user = User.main

    private var wageStr: String {
        if let wage = user.wage {
            return wage.amount.formattedForMoney(includeCents: true)
        }
        return "Not set"
    }

    var body: some View {
        List {
            NavigationLink {
                if let wage = user.wage {
                    WageView(wage: wage)
                } else {
                    EnterWageView()
                }
                
            } label: {
                Text("Hourly wage")
                    .spacedOut(text: wageStr)
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - SettingsView_Previews

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .putInNavView(.inline)
    }
}
