//
//  TagRow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/21/23.
//

import SwiftUI

struct TagRow: View {
    let tag: Tag
    var variation: Int = 2
    
    @ObservedObject private var user = User.main

    var body: some View {
        VStack {
            if variation == 1 {
                variation1
            } else if variation == 2 {
                variation2
            }
        }
        
    }
    
    @ViewBuilder var variation1: some View {
        HStack {
            Components.coloredBar(tag.getColor())

            Image(systemName: tag.getSymbolStr())

            Text(tag.getTitle())
                .font(.callout)
            
            Spacer()
            
            Text(tag.getTotalInstances().str)
                .font(.subheadline)
            
            Components.nextPageChevron
        }
        .frame(maxHeight: 45, alignment: .leading)
//        .padding(.horizontal)
        .background (
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
    }
    
    @ViewBuilder var variation2: some View {
        HStack {
//            Components.coloredBar(tag.getColor())

            Image(systemName: tag.getSymbolStr())
                .foregroundStyle(tag.getColor())

            Text(tag.getTitle())
                .font(.callout)
            
            Spacer()
            
            Text(tag.getTotalInstances().str)
                .font(.subheadline)
            
            Components.nextPageChevron
        }
        .frame(maxHeight: 45, alignment: .leading)
//        .padding(.horizontal)
        .background (
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
    }
}

#Preview {
    ZStack {
        Color.listBackgroundColor
        TagRow(tag: User.main.getTags().randomElement()!)
            
    }
}
