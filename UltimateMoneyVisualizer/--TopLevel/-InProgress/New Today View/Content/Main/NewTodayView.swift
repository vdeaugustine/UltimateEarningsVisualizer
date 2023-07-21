//
//  NewTodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct NewTodayView: View {
    @StateObject private var viewModel: TodayViewModel = .main
    var body: some View {
        ScrollView {
            VStack {
                headerAndBar
                Spacer()
                    .frame(height: 24)
                TodayViewInfoRects()
                    .padding(.horizontal)
                
                
                Spacer()
                    .frame(height: 24)
                
                
                if !viewModel.nonZeroPayoffItems.isEmpty {
                    TodayPaidOffStackWithHeader()
                        .padding(.horizontal)
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
                Spacer()
                    
            }
            .background(Color.targetGray)
            .frame(maxHeight: .infinity)
            
            
        }
        .ignoresSafeArea()
        .background(Color.targetGray)
        .onReceive(viewModel.timer) { _ in
            viewModel.addSecond()
        }
        .environmentObject(viewModel)
        .sheet(isPresented: $viewModel.showHoursSheet) {
            SelectHours()
        }
    }

    var headerAndBar: some View {
        VStack(spacing: -30) {
            TodayViewHeader()
            TodayViewProgressBarAndLabels()
                .padding(.horizontal)
        }
    }

    var infoRects: some View {
        HStack {
            TodayViewInfoRect(imageName: "hourglass", valueString: viewModel.remainingTime.breakDownTime(), bottomLabel: "Remaining")
        }
    }
}

struct NewTodayView_Previews: PreviewProvider {
    static var previews: some View {
        NewTodayView()
            .environmentObject(TodayViewModel.main)
    }
}
