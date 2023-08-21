//
//  NewTagDesign.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/19/23.
//

import SwiftUI

struct NewTagDesign: View {
    let tag: Tag
    var body: some View {
        HStack {
            Components.coloredBar(tag.getColor())
            Text(tag.getTitle())
                .font(.callout)
            
        }
        .padding(.horizontal)
        .frame(height: 40)
        .clipShape(PriceTagShape())
        .overlay {
            PriceTagShape()
                .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
        }
        
    }
}

#Preview {
    NewTagDesign(tag: User.main.getTags().first!)
}
