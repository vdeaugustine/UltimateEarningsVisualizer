//
//  WelcomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/26/23.
//

import SwiftUI
import Vin

// MARK: - FeaturesListView

struct FeaturesListView: View {
    @EnvironmentObject private var vm: OnboardingModel

    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack (spacing: vm.spacingBetweenHeaderAndContent(geo)){
                    Text(vm.featuresHeader)
                        .font(.system(.largeTitle, weight: .bold))
                        .frame(maxWidth: 350)
                        .multilineTextAlignment(.center)
                        .padding(.top, vm.topPadding(geo))
                    
                    
                    
                    ScrollView {
                        VStack(spacing: vm.spacingBetweenHeaderAndContent(geo)) {
                            ForEach(0 ..< 5) { num in // Replace with your data model here
                                if let title = vm.featuresTitles.safeGet(at: num),
                                   let description = vm.featuresDescriptions.safeGet(at: num),
                                   let image = vm.featuresImageStrings.safeGet(at: num) {
                                    HStack {
                                        Image(systemName: image)
                                            .foregroundStyle(.blue)
                                            .font(.system(.title, weight: .regular))
                                            .frame(width: 60, height: 50)
                                            .clipped()
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(title)
                                                .font(.system(.headline, weight: .semibold))
                                            Text(description)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }


                bottomButtons
//                    .padding(.bottom, vm.bottomPadding(geo))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, vm.horizontalPad)
            .padding(.bottom, vm.bottomPadding(geo))
            
            
        }
        
    }
    

    var bottomButtons: some View {
        VStack {
//            HStack(alignment: .firstTextBaseline) {
//                Text("Skip walkthrough")
//                Image(systemName: "chevron.forward")
//                    .imageScale(.small)
//            }
//            .foregroundColor(.blue)
//            .font(.subheadline)
            
            OnboardingButton(title: "Continue") {
                vm.increaseScreenNumber()
            }
        }
    }
}

// MARK: - FeaturesListView_Previews

struct FeaturesListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            FeaturesListView()
//                .previewDevice("iPhone SE (3rd generation)")
//                .onAppear(perform: {
//                    print(UIScreen.main.bounds.size)
//                })
//            FeaturesListView()
//                .previewDevice("iPhone 14 Pro Max")
//                .onAppear(perform: {
//                    print(UIScreen.main.bounds.size)
//                })
//            FeaturesListView()
//                .previewDevice("iPhone 14 Plus")
//                .onAppear(perform: {
//                    print(UIScreen.main.bounds.size)
//                })
//            FeaturesListView()
//                .previewDevice("iPhone 14 Pro")
//                .onAppear(perform: {
//                    print("iPhone 14 Pro", UIScreen.main.bounds.size)
//                })
            FeaturesListView()
                .previewDevice("iPhone 14")
//                .onAppear(perform: {
//                    print("iPhone 14", UIScreen.main.bounds.size)
//                })
//            FeaturesListView()
//                .previewDevice("iPhone 14 Plus")
        }
        .environmentObject(OnboardingModel())
    }
}
