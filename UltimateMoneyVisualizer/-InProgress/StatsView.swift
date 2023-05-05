//
//  StatsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/4/23.
//

import SwiftUI

// MARK: - StatsView

struct StatsView: View {
    enum MoneySection: String, CaseIterable, Identifiable {
        case all, earned, spent, saved, goals
        var id: MoneySection { self }
    }
    
    @State private var selectedSection: MoneySection = .earned

    var body: some View {
        ScrollView {
            Picker("Section", selection: $selectedSection) {
                ForEach(MoneySection.allCases) { section in
                    Text(section.rawValue.capitalized).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            switch selectedSection {
            case .all:
                Text("All")
            case .earned:
                earnedSection
            case .spent:
                spentSection
            case .saved:
                savedSection
            case .goals:
                goalsSection
            }
            
            
        }
        .putInTemplate()
        .navigationTitle("My Stats")
    }

    // MARK: - Earned Section
    var earnedSection: some View {
        VStack {
//            HorizontalDataDisplay(data: [
//                .init(label: "Shifts", value: "something", view: nil),
//                .init(label: "Items", value: "something", view: nil),
//                .init(label: "Time", value: <#T##String#>, view: <#T##AnyView?#>)
//            
//            ])
            
        }
    }
    // MARK: - Saved Section
    var savedSection: some View {
        VStack {
        }
    }
    // MARK: - Spent Section
    var spentSection: some View {
        VStack {
        }
    }
    // MARK: - Goals Section
    var goalsSection: some View {
        VStack {
            
        }
    }
}

// MARK: - StatsView_Previews

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .putInNavView(.inline)
    }
}
