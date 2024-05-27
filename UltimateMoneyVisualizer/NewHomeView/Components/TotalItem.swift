//
//  TotalItem.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/30/23.
//

import SwiftUI

// MARK: - TotalItem

struct TotalItem: View {
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
                
            Text(type.title)
                .format(size: 12,
                        weight: .regular,
                        color: .secondary)
        }
        .overlay {
            if vm.selectedTotalItem == type {
                Color.clear
                    .safeAreaInset(edge: .bottom) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(height: 2)
                            .offset(y: 6)
                    }

//                GeometryReader { geo in

//                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).maxY + 10)
//                }
            }
        }
        .frame(maxWidth: .infinity)
        .allPartsTappable()
//        .pushLeft()
        .onTapGesture {
            vm.selectedTotalItem = type
        }
    }
}

// MARK: - TotalsHeader

struct TotalsHeader: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    var body: some View {
        HStack {
            Text("Totals to Date")
                .font(.callout)
                .fontWeight(.semibold)
            Spacer()
            Text("More Stats")
                .format(size: 14, weight: .medium, color: .textSecondary)
                .onTapGesture {
                    vm.navManager.appendCorrectPath(newValue: .stats)
                }
        }
    }
}

// MARK: - TotalsToDate_HomeView

struct TotalsToDate_HomeView: View {
    
    static let fixedSize: CGFloat = 100
    // Define the grid layout
    let layout = [GridItem(.fixed(fixedSize)),
                  GridItem(.fixed(fixedSize)),
                  GridItem(.fixed(fixedSize))]

    var body: some View {
        VStack(spacing: 40)  {
            TotalsHeader()
            LazyVGrid(columns: layout, alignment: .center, spacing: 16) {
                TotalItem(type: .earned)
                TotalItem(type: .paidOff)
                TotalItem(type: .taxes)
                TotalItem(type: .expenses)
                TotalItem(type: .goals)
                TotalItem(type: .saved)
            }
            .frame(alignment: .center)
            
        }
        .padding(.horizontal)
        
    }
}

// MARK: - TotalItem_Previews

struct TotalItem_Previews: PreviewProvider {
    static var previews: some View {
        TotalItem(type: .expenses)
            .environmentObject(NewHomeViewModel())
    }
}

struct TotalsToDate_HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TotalsToDate_HomeView()
            .environmentObject(NewHomeViewModel.shared)
    }
}

