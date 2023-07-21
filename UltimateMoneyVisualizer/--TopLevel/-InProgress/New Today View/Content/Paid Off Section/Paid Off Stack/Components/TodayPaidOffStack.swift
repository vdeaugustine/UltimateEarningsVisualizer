//
//  TodayPaidOffStack.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayPaidOffStack

struct TodayPaidOffStack: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    let distance: CGFloat = 40

    var limit: CGFloat {
        800
    }

    var minValue: CGFloat {
        min(CGFloat(viewModel.tempPayoffs.count), limit)
    }

    var offsetForStack: CGFloat { 20 }

    var frameWhenStacked: CGFloat { 100 + offsetForStack * minValue }

    var frameWhenFanned: CGFloat { CGFloat(110 * minValue) }

    var totalOffSetWhenFanned: CGFloat { minValue * offsetForStack }

    var zStackHeight: CGFloat { isFannedOut ? frameWhenFanned : frameWhenStacked }

    @State private var isFannedOut = false

    func yPosition(for index: Int) -> CGFloat {
        let firstOffset: CGFloat = 50
        let multiplier: CGFloat = isFannedOut ? 110 : 20
        return firstOffset + multiplier * CGFloat(index)
    }

    var body: some View {
        LazyVStack {
            ForEach(viewModel.nonZeroPayoffItems) { item in
                TodayViewPaidOffRect(item: item)
            }
        }

//        GeometryReader { geo in
//            ZStack(alignment: .top) {
//                ForEach((0 ..< Int(minValue)).reversed(), id: \.self) { index in
//                    if let item = viewModel.tempPayoffs.safeGet(at: Int(minValue) - index),
//                       item.progressAmount > 0.01 {
//                        TodayViewPaidOffRect(item: item)
//                            .position(x: geo.frame(in: .local).midX, y: yPosition(for: index))
//                    }
//                }
//            }
//        }
//        .frame(height: zStackHeight)
//        .onTapGesture {
//            withAnimation {
//                isFannedOut.toggle()
//            }
//        }

//        GeometryReader { geo in
//            ZStack(alignment: .top) {
//                TodayViewPaidOffRect(item: viewModel.tempPayoffs[0])
//                    .position(x: geo.frame(in: .local).midX, y: yPosition(for: 0))
//
//                TodayViewPaidOffRect(item: viewModel.tempPayoffs[1])
//                    .position(x: geo.frame(in: .local).midX, y: yPosition(for: 1))
//
//                TodayViewPaidOffRect(item: viewModel.tempPayoffs[2])
//                    .position(x: geo.frame(in: .local).midX, y: yPosition(for: 2))
//            }
//
//        }
//        .frame(height: zStackHeight)

//        LazyVStack {
//            ZStack {
//                ForEach(0 ..< Int(minValue), id: \.self) { i in
//                    TodayViewPaidOffRect(item: viewModel.tempPayoffs[i])
//                        .offset(y: isFannedOut ? CGFloat(i) * -100 : CGFloat(i) * -offsetForStack)
//                }
//            }
//            .onTapGesture {
//                withAnimation(.spring()) {
//                    isFannedOut.toggle()
//                }
//            }
//            .offset(y: isFannedOut ? totalOffSetWhenFanned : 0)
//        }
//        .frame(height: isFannedOut ? frameWhenFanned : frameWhenStacked)
    }
}

//        VStack {
//            ZStack {
//                if let topItem = viewModel.tempPayoffs.first {
//                    TodayPaidOffRectContainer()
//                    TodayPaidOffRectContainer()
//                        .padding(.bottom, distance)
//                    TodayViewPaidOffRect(item: topItem)
//                        .padding(.bottom, distance * 2)
//                }
//            }
//        }

// MARK: - Card

#Preview {
    ZStack {
        Color.targetGray
        TodayPaidOffStack()
    }
    .environmentObject(TodayViewModel.main)
}
