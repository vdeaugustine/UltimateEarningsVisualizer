//
//  PayoffItemRectGeneral.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/16/23.
//

import SwiftUI

// MARK: - PayoffQueueView_HomeView

struct PayoffItemRectGeneral: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    @ObservedObject private var user = User.main

    let item: PayoffItem

    let arr = [Color.gray,
               Color.green,
               Color.red,
               Color.blue]

    var body: some View {
//            imagePart
//                .clipped()

        HStack {
            imageCircle
            infoPart
        }

//        .frame(height: 300)\

        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .modifier(ShadowForRect())
    }

    var image: Image {
        if let uiImage = item.loadImageIfPresent() {
            return Image(uiImage: uiImage)
        } else {
            return Image("dollar3d")
        }
    }

    var imageCircle: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width: 60, height: 60)
            .clipped()
    }

    @ViewBuilder var imagePart: some View {
        if let image = item.loadImageIfPresent() {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFill()
                .clipped()
                .frame(height: 210)

        } else {
            Image("dollar3d")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaledToFill()
                .clipped()
                .frame(height: 210)
        }
    }

    @ViewBuilder var infoPartTopLine: some View {
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

    @ViewBuilder var infoPart: some View {
        VStack(spacing: 8) {
            infoPartTopLine

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
                HStack(spacing: 3) {
//                    if let createdDay = item.dateCreated {
//                        Text(createdDay.getFormattedDate(format: "M/d"))
//                            .format(size: 14)
//                            .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
//                    }

                    if let dueDate = item.dueDate {
//                        Text("-")
                        Text(dueDate.getFormattedDate(format: "MMM d, Y"))
                            .format(size: 14)
                            .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
                    } else if let createdDay = item.dateCreated {
                        Text(createdDay.getFormattedDate(format: "MMM d, Y"))
                            .format(size: 14)
                            .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
                    }
                }
//
//                    Spacer()
            }
        }
//        .padding(.horizontal, 16)
        .frame(height: 100)
    }
}

struct PayoffItemRectGeneral_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PayoffItemRectGeneral(item: User.main.getGoals().randomElement()!)
            PayoffItemRectGeneral(item: User.main.getExpenses().randomElement()!)
        }
    }
}
