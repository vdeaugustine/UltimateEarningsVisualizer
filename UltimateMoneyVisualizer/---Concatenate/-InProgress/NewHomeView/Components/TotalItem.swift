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
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: type.imageName)
                .font(.system(size: 24))
            Text(type.amount(vm).money()).format(size: 16,
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

        .frame(width: 100)
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
                    vm.navManager.homeNavPath.append(NavManager.AllViews.stats)
//                    print("UPdated nav path", vm.navManager.homeNavPath)
                    print(vm.navManager.homeNavPath.count)
                }
//                .navigationDestination(for: NavManager.AllViews.self) { view in
//                    vm.navManager.getDestinationViewForHomeStack(destination: view)
//                }
                
        }
        
    }
}

// MARK: - TotalsToDate_HomeView

struct TotalsToDate_HomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            TotalsHeader()
            VStack(spacing: 14) {
                HStack {
                    TotalItem(type: .earned)
                    Spacer()
                    TotalItem(type: .paidOff)
                    Spacer()
                    TotalItem(type: .taxes)
                }
                .frame(height: 75)

                HStack {
                    TotalItem(type: .expenses)
                    Spacer()
                    TotalItem(type: .goals)
                    Spacer()
                    TotalItem(type: .saved)
                }
                .frame(height: 75)
            }
            .frame(maxWidth: 285)
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
