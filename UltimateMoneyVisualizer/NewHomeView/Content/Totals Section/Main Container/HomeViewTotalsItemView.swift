//
//  TotalItem.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/30/23.
//

import SwiftUI

// MARK: - TotalItem

struct HomeViewTotalsItemView: View {
    @EnvironmentObject private var vm: NewHomeViewModel
    @ObservedObject private var user = User.main
    var type: NewHomeViewModel.TotalTypes
    

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            type.icon
                .font(.system(size: 24))
            Text(type.amount(user))
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(Color(red: 0.13,
                                       green: 0.13,
                                       blue: 0.13))
                
            Text(type.title)
                .format(size: 12,
                        weight: .regular,
                        color: Color(red: 0.37,
                                     green: 0.37,
                                     blue: 0.37))
        }
        .overlay {
            if vm.selectedTotalItem == type {
                Color.clear
                    .safeAreaInset(edge: .bottom) {
                        Rectangle()
                            .fill(Color(red: 0.87, green: 0.87, blue: 0.87))
                            .frame(height: 2)
                            .offset(y: 6)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .allPartsTappable()
        .onTapGesture {
            vm.selectedTotalItem = type
        }
    }
}


// MARK: - TotalItem_Previews

struct TotalItem_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewTotalsItemView(type: .expenses)
            .environmentObject(NewHomeViewModel())
    }
}

