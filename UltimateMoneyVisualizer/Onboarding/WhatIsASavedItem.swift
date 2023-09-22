//
//  WhatIsASavedItem.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/29/23.
//

import SwiftUI

// MARK: - WhatIsASavedItem

struct WhatIsASavedItem: View {
    @EnvironmentObject private var vm: OnboardingModel


    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 40) {
                Text("Track every saving opportunity")
                    .font(.system(.largeTitle, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                    .layoutPriority(2)

                Image("saving")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: geo.size.width, maxHeight: 250)
                    .layoutPriority(2)

                VStack {
                    Text("Saving money is just as good as earning it!\n\nDid you make coffee today instead of buying it?\n\nMark that down and watch yourself pay off goals & expenses with that saved money")
                        .font(.system(.headline, weight: .regular))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .layoutPriority(1.8)

                    Spacer()

                    OnboardingButton(title: "Let's get started!") {
                        vm.increaseScreenNumber()
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                    .layoutPriority(0)
                }
            }
        }
    }
}

// MARK: - WhatIsASavedItem_Previews

struct WhatIsASavedItem_Previews: PreviewProvider {
    static var previews: some View {
        WhatIsASavedItem()
            .environmentObject(OnboardingModel())
    }
}

