//
//  HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

struct HomeView: View {
    
    var user: User { User.main }
    
    var body: some View {
        List {
            Text("Wage")
                .spacedOut(text: user.wage?.amount.formattedForMoney() ?? "NA")
            
            Text("Total Worked")
                .spacedOut(text: Shift.totalDuration(for: user).formattedForMoney())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
