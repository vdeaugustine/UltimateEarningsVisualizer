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
                Text("A penny saved is a penny earned")
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
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
    //                        VStack(alignment: .leading) {
    //                            HStack {
    //                                Circle().frame(width: 5)
    //                                Text("Make coffee at home instead of buying it?")
    //                            }
    //                            HStack {
    //                                Circle().frame(width: 5)
    //                                Text("Used a coupon at the grocery store?")
    //                            }
    //                            HStack {
    //                                Circle().frame(width: 5)
    //                                Text("Resisted a tempting purchase?")
    //                            }
    //
    //
    //                        }
                            
    //                        Text("Record each moment and witness your savings grow steadily.")
                            
                            VStack(alignment: .leading) {
                                Text("Any moment").font(.headline)
                                
                                Text("It could be as simple as making coffee at home instead of buying it on the way to work.")
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Adds up quick").font(.headline)
                                
                                Text("While these moments might seem small, their collective impact is profound.")
                            }
                            
                            
                            VStack(alignment: .leading){
                                Text("Rewarding").font(.headline)
                                Text("Recording them not only encourages mindful spending but also offers the satisfaction of directing those saved dollars towards achieving your goals.")
                            }
                        }
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)

                    Spacer()

                    OnboardingButton(title: "Record first Saved Item") {
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
