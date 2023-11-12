//
//  NoContentPlaceholderCustomView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/1/23.
//

import SwiftUI

struct NoContentPlaceholderCustomView: View {
    // Dynamic Properties
    var title: String
    var subTitle: String
    var imageSystemName: String
    var buttonTitle: String? = nil
    var buttonColor: Color? = nil
    var onButtonTap: (() -> Void)? = nil

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: imageSystemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 85)
                .foregroundColor(.gray)

            VStack(spacing: 14) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text(subTitle)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
            }

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, content: {
            if let onButtonTap,
               let buttonTitle,
               let buttonColor {
                Button {
                    onButtonTap()
                } label: {
                    ZStack {
                        Capsule()
                            .fill(buttonColor.getGradient())
                        Text(buttonTitle)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(width: 135, height: 50)
                }
            }

        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background (Color(.secondarySystemBackground))
    }
}

#Preview {
//    NoContentPlaceholderCustomView(title: "Today's Shift",
//                                   subTitle: "You do not have a shift scheduled for today.",
//                                   imageSystemName: "calendar.badge.clock",
//                                   buttonTitle: "Save",
//                                   buttonColor: Color.green
//    ) {
//        print("Was tapped")
//    }

    NoContentPlaceholderCustomView(title: "Today's Shift",
                                   subTitle: "You do not have a shift scheduled for today.",
                                   imageSystemName: "calendar.badge.clock")
    
}
