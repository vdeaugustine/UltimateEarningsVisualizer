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

    let type: NewHomeViewModel.TotalTypes

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            type.icon
                .font(.system(size: 24))
            Text(type.amount(vm))
                .format(size: 16,
                        weight: .semibold,
                        color: Color(red: 0.13,
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
                            .offset(y: 10)
                    }

//                GeometryReader { geo in

//                        .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).maxY + 10)
//                }
            }
        }
        .frame(maxWidth: .infinity)
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
                .format(size: 16, weight: .semibold)
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
            LazyVGrid(columns: layout, alignment: .center) {
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

