//
//  PayoffQueueView_HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/30/23.
//

import SwiftUI

// MARK: - PayoffQueueView_HomeView

struct PayoffQueueView_HomeView: View {
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
        TabView {
            VStack(spacing: 0) {
                if let item = payoffItemDisplayed {
                    ImagePart(index: $index)
                    InfoPart(item: item)
                } else {
                    Text("No item found")
                }
            }
        }

        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 300)

        .background {
            Color.white
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
        .padding(.horizontal)
    }

    struct ImagePart: View {
        @Binding var index: Int
        @State private var selectedIndex: Int = 0
        var body: some View {
            TabView(selection: $selectedIndex) {
                ForEach(User.main.getQueue().indices, id: \.self) { queueIndex in

                    if let item = User.main.getQueue().safeGet(at: queueIndex),
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
        }
    }

    struct InfoPart: View {
        let item: PayoffItem
        var body: some View {
            VStack(spacing: 8) {
                TopLine(item: item)

                // Temporary Progress Bar
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 300, height: 10)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(10)

                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 95, height: 10)
                        .background(Color(red: 0.08, green: 0.23, blue: 0.75))
                        .cornerRadius(10)
                }

                HStack(spacing: 4) {
                    Text("$120")
                        .format(size: 14, weight: .semibold)
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                    Circle()
                        .fill(Color(red: 0.37, green: 0.37, blue: 0.37))
                        .frame(width: 2, height: 2)

                    // Body Copy/14pt Regular
                    Text("Apr 17-22")
                        .format(size: 14)
                        .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))

                    Spacer()
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
    }
}
