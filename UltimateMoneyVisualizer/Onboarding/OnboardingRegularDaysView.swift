//
//  OnboardingThirdView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/26/23.
//

import SwiftUI

struct OnboardingRegularDaysView: View {
    
    @EnvironmentObject private var model: OnboardingModel
    
    var body: some View {
        VStack {
            Text("What are your normal working days?")
                .font(.system(.largeTitle, weight: .bold))
                .frame(minWidth: 240)
                .clipped()
                .multilineTextAlignment(.center)
//                .padding(.top, 82)
                .padding(.bottom)
            VStack(spacing: 28) {
                ForEach(DayOfWeek.orderedCases) { day in // Replace with your data model here
                    HStack {
                        Button {
                            model.daysSelected.insertOrRemove(element: day)
                        } label: {
                            HStack {
                                Image(systemName: model.daysSelected.contains(day) ? "checkmark.circle" : "circle")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.monochrome)
                                    
                                Text(day.description)
                                    .font(.title2)
                                Spacer()
                            }
                        }
                        .foregroundStyle(Color.black)
                        
                        
                        Spacer()
                        
                        if model.daysSelected.contains(day) {
                            HStack {
                                Text(model.getTimeString(for: day))
                                    .font(.subheadline)
                            }
                            .padding(10)
                            .background {
                                Color.listBackgroundColor
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        
                        
                    }
                    
                    
                }
            }
            
            Spacer()
            OnboardingButton(title: "Continue") {
                model.increaseScreenNumber()
            }
                
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .padding(.horizontal, 30)
        .padding(.bottom, 50)
        .overlay(alignment: .top) {
            Group {
                
            }
        }
    }
}

struct OnboardingThirdView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            OnboardingRegularDaysView()
                .previewDevice("iPhone SE (3rd generation)")
            OnboardingRegularDaysView()
                .previewDevice("iPhone 14 Pro Max")
        }
        .environmentObject(OnboardingModel())
    }
}
