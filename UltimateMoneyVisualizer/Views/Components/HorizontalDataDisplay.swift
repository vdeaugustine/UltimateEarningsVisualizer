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
        static func == (lhs: HorizontalDataDisplay.DataItem, rhs: HorizontalDataDisplay.DataItem) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(label)
            hasher.combine(value)
        }
        
        let label: String
        let value: String
        let view: AnyView?
        var id: String { value }
    }

    @ObservedObject var settings = User.main.getSettings()

    var body: some View {
        Section {
            HStack {
                ForEach(data.indices, id: \.self) { index in
                    if let datum = data.safeGet(at: index) {
                        if let view = datum.view {
                            NavigationLink(destination: view) {
                                VStack {
                                    Text(datum.label)
                                        .fontWeight(.medium)
                                        .minimumScaleFactor(0.01)
                                    Text(datum.value)
                                        .fontWeight(.bold)
                                        .foregroundStyle(settings.getDefaultGradient())
                                        .minimumScaleFactor(0.01)
                                }.padding(.horizontal)
                            }.buttonStyle(PlainButtonStyle())
                        }
                        else {
                            VStack {
                                Text(datum.label)
                                    .fontWeight(.medium)
                                    .minimumScaleFactor(0.01)
                                Text(datum.value)
                                    .fontWeight(.bold)
                                    .foregroundStyle(settings.getDefaultGradient())
                                    .minimumScaleFactor(0.01)
                            }
                            .padding(.horizontal)
                        }
                        

                        
                    }
                    if index < data.count - 1 {
                        Divider().padding(.vertical)
                    }
                }
            }.frame(height: 80)
        }
    }
}



// MARK: - HorizontalDataDisplay_Previews

struct HorizontalDataDisplay_Previews: PreviewProvider {
    
    static let exampleData = [
        HorizontalDataDisplay.DataItem(
            label: "Item 1",
            value: "1",
            view: AnyView(Text("This is Item 1's view"))
        ),
        HorizontalDataDisplay.DataItem(
            label: "Item 2",
            value: "2",
            view: AnyView(Text("This is Item 2's view"))
        )
    ]
    
    static var previews: some View {
        HorizontalDataDisplay(data: exampleData)
    }
}

