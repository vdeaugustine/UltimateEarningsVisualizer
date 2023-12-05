//
//  PayoffQueueView_HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/30/23.
//

import SwiftUI

// MARK: - PayoffQueueView_HomeView

struct PayoffQueueView_HomeView: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    @State private var payoffQueueIndexDisplayed: Int = 0
    @State private var selectedTab: Int = 0
    @ObservedObject private var user = User.main
    @State private var index: Int = 0

    var payoffItemDisplayed: PayoffItem? {
        user.getQueue().safeGet(at: index)
//        user.getItemWith(queueSlot: payoffQueueIndexDisplayed)
    }

    let arr = [Color.gray,
               Color.green,
               Color.red,
               Color.blue]

    var body: some View {
        VStack {
            HStack {
                // SectionHeader-HomeView
                Text("Payoff Queue")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Button {
                    vm.navManager.appendCorrectPath(newValue: .oldPayoffQueue)

                } label: {
                    Image(systemName: "ellipsis")
                        .font(.callout)
                }
                .foregroundStyle(.black)
            }
            .padding(.horizontal)

            rectWithItems
        }
    }

    @ViewBuilder var rectWithItems: some View {
        VStack(spacing: 0) {
            if let item = payoffItemDisplayed {
                ImagePart(index: $index)
                InfoPart(item: item)
            } else {
                Text("Payoff queue is empty")
            }
        }

        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .modifier(ShadowForRect())
        .padding(.horizontal)
        .onTapGesture {
            print("tapped")
            vm.payoffItemTapped(payoffItemDisplayed)
        }
    }

    struct ImagePart: View {
        @Binding var index: Int
        @State private var selectedIndex: Int = 0
        @ObservedObject var user = User.main
        var body: some View {
            TabView(selection: $selectedIndex) {
                ForEach(user.getQueue().indices, id: \.self) { queueIndex in

                    if let item = user.getQueue().safeGet(at: queueIndex),
                       let image = item.loadImageIfPresent() {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFill()
                            .clipped()
                            .id(queueIndex)
                    } else {
                        Image("dollar3d")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFill()
                            .clipped()
                            .id(queueIndex)
                    }
                }
            }
            .frame(height: 210)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .onChange(of: selectedIndex, perform: { _ in
                print(selectedIndex)
                index = selectedIndex
            })
            .overlay {
                if var item = user.getQueue().safeGet(at: selectedIndex) {
                    VStack {
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 35)
                                .overlay {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .fontWeight(.light)
                                        .rotationEffect(.degrees(45))
                                        .foregroundStyle(Color.white)
                                }
                                .onTapGesture {
                                    item.optionalQSlotNumber = nil
                                    do {
                                        try user.getContext().save()
                                        print("Saved")
                                        withAnimation {
                                            if user.getQueue().safeCheck(selectedIndex - 1) {
                                                selectedIndex -= 1
                                            } else if user.getQueue().safeCheck(selectedIndex + 1) {
                                                selectedIndex += 1
                                            }
                                        }
                                    } catch {
                                        print("error saving")
                                    }
                                }

                            Spacer()

                            if item.amountRemainingToPayOff <= 0.01 {
                                Circle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 35)
                                    .overlay {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(Color.white)
                                    }
                                    .onTapGesture {
                                        item.optionalQSlotNumber = nil
                                        do {
                                            try user.getContext().save()
                                            print("Saved")
                                            withAnimation {
                                                if user.getQueue().safeCheck(selectedIndex - 1) {
                                                    selectedIndex -= 1
                                                } else if user.getQueue().safeCheck(selectedIndex + 1) {
                                                    selectedIndex += 1
                                                }
                                            }
                                        } catch {
                                            print("error saving")
                                        }
                                    }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
            }
        }
    }

    struct InfoPart: View {
        let item: PayoffItem
        var body: some View {
            VStack(spacing: 8) {
                TopLine(item: item)

                ProgressBar(percentage: item.percentPaidOff, height: 10)
//                // Temporary Progress Bar
//                ZStack(alignment: .leading) {
//                    Rectangle()
//                        .foregroundColor(.clear)
//                        .frame(width: 300, height: 10)
//                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
//                        .cornerRadius(10)
//
//                    Rectangle()
//                        .foregroundColor(.clear)
//                        .frame(width: 95, height: 10)
//                        .background(Color(red: 0.08, green: 0.23, blue: 0.75))
//                        .cornerRadius(10)
//                }

                HStack(spacing: 4) {
                    Text(item.amountPaidOff.money())
                        .format(size: 14, weight: .semibold)
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
//                    Circle()
//                        .fill(Color(red: 0.37, green: 0.37, blue: 0.37))
//                        .frame(width: 2, height: 2)
                    Spacer()

                    // Body Copy/14pt Regular
                    Text("Apr 17-22")
                        .format(size: 14)
                        .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
//
//                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: 200)
        }

        struct TopLine: View {
            let item: PayoffItem
            var body: some View {
                HStack {
                    Text(item.titleStr)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))

                    Spacer()

                    Text(item.amountMoneyStr)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                }
            }
        }
    }
}

// MARK: - PayoffQueueView_HomeView_Previews

struct PayoffQueueView_HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PayoffQueueView_HomeView()
            .templateForPreview()
            .environmentObject(NewHomeViewModel.shared)
    }
}
