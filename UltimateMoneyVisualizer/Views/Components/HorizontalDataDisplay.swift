//
//  HorizontalDataDisplay.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import SwiftUI

// MARK: - HorizontalDataDisplay

struct HorizontalDataDisplay: View {

    let data: [DataItem]

    struct DataItem: Identifiable, Hashable {
        let label: String
        let value: String
        let id = UUID()
    }

    @ObservedObject var settings = User.main.getSettings()
    
    var body: some View {
        Section {
            HStack {
                ForEach(data) { datum in
                    VStack {
                        Text(datum.label)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(datum.value)
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)

                    }.padding(.horizontal)
                    if let last = data.last,
                       last != datum {
                        Divider().padding(.vertical)
                    }
                }
            }

            .frame(height: 80)
        }
    }
}

// MARK: - HorizontalDataDisplay_Previews

struct HorizontalDataDisplay_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalDataDisplay(data: [.init(label: "Items", value: "3"),
                                     .init(label: "Amount", value: "$123"),
                                     .init(label: "Time", value: "10h")])
    }
}

